#include "runtime.h"
#include "ext/standard/info.h"

PHP_MINIT_FUNCTION(mindbrix)
{
	/* Nothing in the binary adopts RASceneListDelegate, so this reference is what puts the
	 * protocol in the Objective-C runtime for appkit's ObjCDelegate to find by name. */
	(void) @protocol(RASceneListDelegate);

	mindbrix_register_RasterizerAPI(module_number);
	mindbrix_register_RasterizerView(module_number);
	return SUCCESS;
}

PHP_RINIT_FUNCTION(mindbrix)
{
#if defined(COMPILE_DL_MINDBRIX) && defined(ZTS)
	ZEND_TSRMLS_CACHE_UPDATE();
#endif
	return SUCCESS;
}

PHP_MINFO_FUNCTION(mindbrix)
{
	php_info_print_table_start();
	php_info_print_table_header(2, "mindbrix support", "enabled");
	php_info_print_table_row(2, "Version", PHP_MINDBRIX_VERSION);
	php_info_print_table_row(2, "mindbrix/Rasterizer", PHP_MINDBRIX_RASTERIZER_COMMIT);
	php_info_print_table_end();
}

/* appkit registers the classes mindbrix's extend; load order follows from this. */
static const zend_module_dep mindbrix_deps[] = {
	ZEND_MOD_REQUIRED("appkit")
	ZEND_MOD_END
};

zend_module_entry mindbrix_module_entry = {
	STANDARD_MODULE_HEADER_EX,
	NULL,
	mindbrix_deps,
	"mindbrix",
	NULL,
	PHP_MINIT(mindbrix),
	NULL,
	PHP_RINIT(mindbrix),
	NULL,
	PHP_MINFO(mindbrix),
	PHP_MINDBRIX_VERSION,
	STANDARD_MODULE_PROPERTIES
};

#ifdef COMPILE_DL_MINDBRIX
# ifdef ZTS
ZEND_TSRMLS_CACHE_DEFINE()
# endif
ZEND_GET_MODULE(mindbrix)
#endif
