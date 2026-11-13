#ifndef PHP_MINDBRIX_H
#define PHP_MINDBRIX_H

extern zend_module_entry mindbrix_module_entry;
#define phpext_mindbrix_ptr &mindbrix_module_entry

#define PHP_MINDBRIX_VERSION "0.11.0"

/* lib/Rasterizer: mindbrix/Rasterizer at this commit (its CHANGELOG's 0.1.0, untagged upstream). */
#define PHP_MINDBRIX_RASTERIZER_COMMIT "2be4bc16"

#if defined(ZTS) && defined(COMPILE_DL_MINDBRIX)
ZEND_TSRMLS_CACHE_EXTERN()
#endif

#endif
