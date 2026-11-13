/* This is a generated file, edit the .stub.php file instead.
 * Stub hash: 908181519876518d0b27396cb0279753e897aa6d */

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RasterizerView_listDelegate, 0, 0, NSObject, 1)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RasterizerView_setListDelegate, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, listDelegate, NSObject, 1)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RasterizerView_useCG, 0, 0, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RasterizerView_setUseCG, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, useCG, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

ZEND_METHOD(RasterizerView, listDelegate);
ZEND_METHOD(RasterizerView, setListDelegate);
ZEND_METHOD(RasterizerView, useCG);
ZEND_METHOD(RasterizerView, setUseCG);

static const zend_function_entry class_RasterizerView_methods[] = {
	ZEND_ME(RasterizerView, listDelegate, arginfo_class_RasterizerView_listDelegate, ZEND_ACC_PUBLIC)
	ZEND_ME(RasterizerView, setListDelegate, arginfo_class_RasterizerView_setListDelegate, ZEND_ACC_PUBLIC)
	ZEND_ME(RasterizerView, useCG, arginfo_class_RasterizerView_useCG, ZEND_ACC_PUBLIC)
	ZEND_ME(RasterizerView, setUseCG, arginfo_class_RasterizerView_setUseCG, ZEND_ACC_PUBLIC)
	ZEND_FE_END
};

static zend_class_entry *register_class_RasterizerView(zend_class_entry *class_entry_NSView)
{
	zend_class_entry ce, *class_entry;

	INIT_CLASS_ENTRY(ce, "RasterizerView", class_RasterizerView_methods);
	class_entry = zend_register_internal_class_with_flags(&ce, class_entry_NSView, ZEND_ACC_NOT_SERIALIZABLE);

	return class_entry;
}
