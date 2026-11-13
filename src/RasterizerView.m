#include "runtime.h"
#include "../stubs/RasterizerView_arginfo.h"

zend_class_entry *mindbrix_ce_RasterizerView;

#define THIS_VIEW ((RasterizerView *) APPKIT_ID(Z_OBJ_P(ZEND_THIS)))

void mindbrix_register_RasterizerView(int module_number)
{
	mindbrix_ce_RasterizerView = register_class_RasterizerView(appkit_ce_NSView);
	appkit_object_setup(mindbrix_ce_RasterizerView);
	appkit_map_objc_class("RasterizerView", mindbrix_ce_RasterizerView);
}

/*
 * RasterizerView is an NSView: like appkit's views, every method is gated to the main thread.
 * The delegate is held weakly by the view; the getter answers it while something else keeps it.
 */

ZEND_METHOD(RasterizerView, listDelegate)
{
	ZEND_PARSE_PARAMETERS_NONE();
	APPKIT_REQUIRE_MAIN_THREAD();

	APPKIT_BEGIN
		appkit_box_objc(return_value, (id) THIS_VIEW.listDelegate);
	APPKIT_END
}

ZEND_METHOD(RasterizerView, setListDelegate)
{
	zend_object *listDelegate = NULL;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS_OR_NULL(listDelegate, appkit_ce_NSObject)
	ZEND_PARSE_PARAMETERS_END();
	APPKIT_REQUIRE_MAIN_THREAD();

	APPKIT_BEGIN
		THIS_VIEW.listDelegate = listDelegate != NULL ? (id<RASceneListDelegate>) APPKIT_ID(listDelegate) : nil;
	APPKIT_END
}

ZEND_METHOD(RasterizerView, useCG)
{
	ZEND_PARSE_PARAMETERS_NONE();
	APPKIT_REQUIRE_MAIN_THREAD();

	APPKIT_BEGIN
		RETVAL_BOOL(THIS_VIEW.useCG);
	APPKIT_END
}

ZEND_METHOD(RasterizerView, setUseCG)
{
	bool useCG;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_BOOL(useCG)
	ZEND_PARSE_PARAMETERS_END();
	APPKIT_REQUIRE_MAIN_THREAD();

	APPKIT_BEGIN
		THIS_VIEW.useCG = useCG;
	APPKIT_END
}
