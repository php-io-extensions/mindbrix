PHP_ARG_ENABLE([mindbrix],
  [whether to enable mindbrix support],
  [AS_HELP_STRING([--enable-mindbrix], [Enable mindbrix/Rasterizer (Metal vector rendering) bindings])],
  [no])

if test "$PHP_MINDBRIX" != "no"; then
  case $host_os in
    darwin*) ;;
    *) AC_MSG_ERROR([mindbrix binds mindbrix/Rasterizer, which renders with Metal: macOS only]) ;;
  esac

  dnl mindbrix's classes are ext-appkit objects: it compiles against appkit's installed headers.
  if test -n "$PHP_CONFIG"; then
    mindbrix_appkit_inc="`$PHP_CONFIG --include-dir`/ext/appkit"
  else
    mindbrix_appkit_inc="$phpincludedir/ext/appkit"
  fi
  if test ! -f "$mindbrix_appkit_inc/php_appkit_api.h"; then
    AC_MSG_ERROR([mindbrix needs ext-appkit installed first: $mindbrix_appkit_inc/php_appkit_api.h not found])
  fi

  dnl The binding (Objective-C, manual retain/release, as appkit and avkit).
  MINDBRIX_SOURCES="src/mindbrix.m src/shaders.m src/RasterizerAPI.m src/RasterizerView.m"

  dnl Rasterizer itself, unchanged from upstream (lib/Rasterizer). Its Objective-C++ is ARC, as upstream builds it.
  MINDBRIX_RA=lib/Rasterizer/Package/Sources
  MINDBRIX_VENDOR_C="$MINDBRIX_RA/RasterizerCpp/xxhash.c"
  MINDBRIX_VENDOR_CC="$MINDBRIX_RA/RasterizerCpp/nanosvg.cc"
  MINDBRIX_VENDOR_MM="$MINDBRIX_RA/RasterizerObjC/RasterizerAPI.mm $MINDBRIX_RA/RasterizerObjC/RasterizerLayer.mm $MINDBRIX_RA/RasterizerObjC/RasterizerView.mm"

  PHP_NEW_EXTENSION([mindbrix], [], [$ext_shared],, [-DZEND_ENABLE_STATIC_TSRMLS_CACHE=1])
  PHP_ADD_BUILD_DIR([$ext_builddir/src])
  PHP_ADD_BUILD_DIR([$ext_builddir/$MINDBRIX_RA/RasterizerCpp])
  PHP_ADD_BUILD_DIR([$ext_builddir/$MINDBRIX_RA/RasterizerObjC])

  dnl PHP_ADD_SOURCES only knows .c/.s/.S/.cpp, so every rule is written the way
  dnl PHP_ADD_SOURCES_X writes a .c rule: shared objects for a phpize build, PHP's
  dnl own objects when compiled into PHP.
  case $ext_dir in
    "") mindbrix_srcdir="$abs_srcdir/"; mindbrix_bdir="" ;;
    *) mindbrix_srcdir="$abs_srcdir/$ext_dir/"; mindbrix_bdir="$ext_dir/" ;;
  esac
  mindbrix_ra_inc="-I${mindbrix_srcdir}$MINDBRIX_RA/RasterizerCpp/include -I${mindbrix_srcdir}$MINDBRIX_RA/RasterizerObjC/include -I${mindbrix_srcdir}$MINDBRIX_RA/RasterizerObjC/private"
  mindbrix_inc="-I. -I${mindbrix_srcdir} -I$mindbrix_appkit_inc $mindbrix_ra_inc"
  if test "$ext_shared" = "yes"; then
    mindbrix_cc="$shared_c_pre $mindbrix_inc $shared_c_meta -DZEND_COMPILE_DL_EXT=1"
    mindbrix_post=$shared_c_post
  else
    mindbrix_cc="$php_c_pre $mindbrix_inc $php_c_meta"
    mindbrix_post=$php_c_post
  fi

  dnl Rasterizer's layer loads its shaders with -[MTLDevice newDefaultLibrary], which in a
  dnl SwiftPM build finds the package's compiled .metallib. PHP has no such bundle, so
  dnl src/prelude.h, force-included into RasterizerLayer.mm alone, turns that one call into
  dnl newLibraryWithSource: over the shader source the binding carries (src/shaders.inc).
  mindbrix_prelude="-include ${mindbrix_srcdir}src/prelude.h"

  mindbrix_rule() {
    mindbrix_obj=$mindbrix_bdir$(echo "$1" | $SED -e 's/\.[[a-z]]*$//')
    if test "$ext_shared" = "yes"; then
      shared_objects_mindbrix="$shared_objects_mindbrix $mindbrix_obj.lo"
    else
      PHP_GLOBAL_OBJS="$PHP_GLOBAL_OBJS $mindbrix_obj.lo"
    fi
    cat >>Makefile.objects<<EOF
-include $mindbrix_obj.dep
$mindbrix_obj.lo: $mindbrix_srcdir$1
	$mindbrix_cc -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 $2 -c $mindbrix_srcdir$1 -o $mindbrix_obj.lo $mindbrix_post -MMD -MF $mindbrix_obj.dep -MT $mindbrix_obj.lo
EOF
  }

  for mindbrix_src in $MINDBRIX_SOURCES; do
    mindbrix_rule "$mindbrix_src" "-x objective-c -fno-objc-arc -fobjc-exceptions -Wno-unused-parameter"
  done
  for mindbrix_src in $MINDBRIX_VENDOR_C; do
    mindbrix_rule "$mindbrix_src" "-x c -O2 -w"
  done
  for mindbrix_src in $MINDBRIX_VENDOR_CC; do
    mindbrix_rule "$mindbrix_src" "-x c++ -std=c++17 -O2 -w"
  done
  for mindbrix_src in $MINDBRIX_VENDOR_MM; do
    mindbrix_extra=""
    case $mindbrix_src in
      *RasterizerLayer.mm) mindbrix_extra="$mindbrix_prelude" ;;
    esac
    mindbrix_rule "$mindbrix_src" "-x objective-c++ -std=c++17 -fobjc-arc -fobjc-exceptions -O2 -w $mindbrix_extra"
  done

  dnl Only get_module is exported: Rasterizer's C/C++ symbols (xxhash, nanosvg) stay
  dnl private, so another copy loaded into the process can neither take ours nor be taken.
  MINDBRIX_FRAMEWORKS="Foundation AppKit CoreGraphics CoreText QuartzCore Metal"
  if test "$ext_shared" = "yes"; then
    MINDBRIX_SHARED_LIBADD="-Wl,-exported_symbol,_get_module -lc++ -lobjc"
    for mindbrix_framework in $MINDBRIX_FRAMEWORKS; do
      MINDBRIX_SHARED_LIBADD="$MINDBRIX_SHARED_LIBADD -framework $mindbrix_framework"
    done
    PHP_SUBST([MINDBRIX_SHARED_LIBADD])
  else
    for mindbrix_framework in $MINDBRIX_FRAMEWORKS; do
      PHP_ADD_FRAMEWORK([$mindbrix_framework])
    done
    PHP_ADD_LIBRARY([objc])
    PHP_ADD_LIBRARY([c++])
  fi
fi
