/* This is a generated file, edit the .stub.php file instead.
 * Stub hash: ac5b05341e9f4238da80a1394358e25c2b7fa871 */

ZEND_BEGIN_ARG_INFO_EX(arginfo_class_CGAffineTransform___construct, 0, 0, 6)
	ZEND_ARG_TYPE_INFO(0, a, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, b, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, c, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, d, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, tx, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, ty, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPaint_init, 0, 0, IS_STATIC, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPaint_initWithGrayAlpha, 0, 2, IS_STATIC, 0)
	ZEND_ARG_TYPE_INFO(0, gray, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, alpha, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPaint_initWithHueSaturationValueAlpha, 0, 4, IS_STATIC, 0)
	ZEND_ARG_TYPE_INFO(0, hue, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, saturation, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, value, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, alpha, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPaint_initWithRedGreenBlueAlpha, 0, 4, IS_STATIC, 0)
	ZEND_ARG_TYPE_INFO(0, red, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, green, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, blue, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, alpha, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPaint_initWithCGColor, 0, 1, IS_STATIC, 0)
	ZEND_ARG_OBJ_INFO(0, cgColor, CGColor, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPaint_initLinearLocationsStartEnd, 0, 4, IS_STATIC, 0)
	ZEND_ARG_TYPE_INFO(0, colors, IS_ARRAY, 0)
	ZEND_ARG_TYPE_INFO(0, locations, IS_ARRAY, 0)
	ZEND_ARG_OBJ_INFO(0, start, NSPoint, 0)
	ZEND_ARG_OBJ_INFO(0, end, NSPoint, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPaint_initRadialLocationsCenterRadius, 0, 4, IS_STATIC, 0)
	ZEND_ARG_TYPE_INFO(0, colors, IS_ARRAY, 0)
	ZEND_ARG_TYPE_INFO(0, locations, IS_ARRAY, 0)
	ZEND_ARG_OBJ_INFO(0, center, NSPoint, 0)
	ZEND_ARG_TYPE_INFO(0, radius, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPaint_initWithCGImage, 0, 1, IS_STATIC, 0)
	ZEND_ARG_OBJ_INFO(0, cgImage, CGImage, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RAPath_init arginfo_class_RAPaint_init

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RAPath_bounds, 0, 0, NSRect, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_initWithCGPath, 0, 1, IS_STATIC, 0)
	ZEND_ARG_OBJ_INFO(0, cgPath, CFType, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_initWithRect, 0, 1, IS_STATIC, 0)
	ZEND_ARG_OBJ_INFO(0, rect, NSRect, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RAPath_initWithEllipse arginfo_class_RAPath_initWithRect

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_initWithRoundedRectCornerWidthCornerHeight, 0, 3, IS_STATIC, 0)
	ZEND_ARG_OBJ_INFO(0, rect, NSRect, 0)
	ZEND_ARG_TYPE_INFO(0, cornerWidth, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, cornerHeight, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_moveToY, 0, 2, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, x, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, y, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RAPath_lineToY arginfo_class_RAPath_moveToY

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_quadToY1X2Y2, 0, 4, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, x1, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, y1, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, x2, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, y2, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_cubicToY1X2Y2X3Y3, 0, 6, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, x1, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, y1, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, x2, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, y2, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, x3, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, y3, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_close, 0, 0, IS_VOID, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_addCGPath, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, path, CFType, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_addRect, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, rect, NSRect, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RAPath_addEllipse arginfo_class_RAPath_addRect

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAPath_addRoundedRectCornerWidthCornerHeight, 0, 3, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, rect, NSRect, 0)
	ZEND_ARG_TYPE_INFO(0, cornerWidth, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, cornerHeight, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RAPath_dashedCopyWithPhaseLengths, 0, 2, RAPath, 0)
	ZEND_ARG_TYPE_INFO(0, phase, IS_DOUBLE, 0)
	ZEND_ARG_TYPE_INFO(0, lengths, IS_ARRAY, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RADraw_init arginfo_class_RAPaint_init

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_initWithPathCtmColor, 0, 3, IS_STATIC, 0)
	ZEND_ARG_OBJ_INFO(0, path, RAPath, 0)
	ZEND_ARG_OBJ_INFO(0, ctm, CGAffineTransform, 0)
	ZEND_ARG_OBJ_INFO(0, color, RAPaint, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RADraw_path, 0, 0, RAPath, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setPath, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, path, RAPath, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RADraw_ctm, 0, 0, CGAffineTransform, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setCtm, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, ctm, CGAffineTransform, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RADraw_color, 0, 0, RAPaint, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setColor, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, color, RAPaint, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_width, 0, 0, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setWidth, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, width, IS_DOUBLE, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_evenOdd, 0, 0, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setEvenOdd, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, evenOdd, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RADraw_capStyle, 0, 0, RACapStyle, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setCapStyle, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, capStyle, RACapStyle, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RADraw_joinStyle, 0, 0, RAJoinStyle, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setJoinStyle, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, joinStyle, RAJoinStyle, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RADraw_clip arginfo_class_RAPath_bounds

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setClip, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, clip, NSRect, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RADraw_clipPath, 0, 0, RAPath, 1)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setClipPath, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, clipPath, RAPath, 1)
ZEND_END_ARG_INFO()

#define arginfo_class_RADraw_clipEvenOdd arginfo_class_RADraw_evenOdd

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setClipEvenOdd, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, clipEvenOdd, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RADraw_hidden arginfo_class_RADraw_evenOdd

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setHidden, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, hidden, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RADraw_blendMode, 0, 0, RABlendMode, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RADraw_setBlendMode, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, blendMode, RABlendMode, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RAScene_init arginfo_class_RAPaint_init

#define arginfo_class_RAScene_bounds arginfo_class_RAPath_bounds

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAScene_count, 0, 0, IS_LONG, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAScene_addDraw, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, draw, RADraw, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAScene_addImageCtm, 0, 2, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, image, RAPaint, 0)
	ZEND_ARG_OBJ_INFO(0, ctm, CGAffineTransform, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAScene_addFillCtmColorEvenOddClipClipPathBlendMode, 0, 7, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, path, RAPath, 0)
	ZEND_ARG_OBJ_INFO(0, ctm, CGAffineTransform, 0)
	ZEND_ARG_OBJ_INFO(0, color, RAPaint, 0)
	ZEND_ARG_TYPE_INFO(0, evenOdd, _IS_BOOL, 0)
	ZEND_ARG_OBJ_INFO(0, clip, NSRect, 0)
	ZEND_ARG_OBJ_INFO(0, clipPath, RAPath, 1)
	ZEND_ARG_OBJ_INFO(0, blendMode, RABlendMode, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAScene_addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode, 0, 9, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, path, RAPath, 0)
	ZEND_ARG_OBJ_INFO(0, ctm, CGAffineTransform, 0)
	ZEND_ARG_OBJ_INFO(0, color, RAPaint, 0)
	ZEND_ARG_TYPE_INFO(0, width, IS_DOUBLE, 0)
	ZEND_ARG_OBJ_INFO(0, capStyle, RACapStyle, 0)
	ZEND_ARG_OBJ_INFO(0, joinStyle, RAJoinStyle, 0)
	ZEND_ARG_OBJ_INFO(0, clip, NSRect, 0)
	ZEND_ARG_OBJ_INFO(0, clipPath, RAPath, 1)
	ZEND_ARG_OBJ_INFO(0, blendMode, RABlendMode, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RAScene_addTextInRectCtmClip, 0, 4, NSRect, 0)
	ZEND_ARG_OBJ_INFO(0, string, NSAttributedString, 0)
	ZEND_ARG_OBJ_INFO(0, rect, NSRect, 0)
	ZEND_ARG_OBJ_INFO(0, ctm, CGAffineTransform, 0)
	ZEND_ARG_OBJ_INFO(0, clip, NSRect, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAScene_pdfPageCountFromUrl, 0, 1, IS_LONG, 0)
	ZEND_ARG_OBJ_INFO(0, url, NSURL, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RAScene_addPdfFromUrlPageIndex, 0, 2, CGAffineTransform, 0)
	ZEND_ARG_OBJ_INFO(0, url, NSURL, 0)
	ZEND_ARG_TYPE_INFO(0, pageIndex, IS_LONG, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_RAScene_addSvgFromUrl, 0, 1, CGAffineTransform, 0)
	ZEND_ARG_OBJ_INFO(0, url, NSURL, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RAScene_updateDrawsInRangeUsingBlock, 0, 2, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, range, NSRange, 0)
	ZEND_ARG_TYPE_INFO(0, block, IS_CALLABLE, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RASceneList_init arginfo_class_RAPaint_init

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_initWithScene, 0, 1, IS_STATIC, 0)
	ZEND_ARG_OBJ_INFO(0, scene, RAScene, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RASceneList_bounds arginfo_class_RAPath_bounds

#define arginfo_class_RASceneList_ctm arginfo_class_RADraw_ctm

#define arginfo_class_RASceneList_setCtm arginfo_class_RADraw_setCtm

#define arginfo_class_RASceneList_clearColor arginfo_class_RADraw_color

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_setClearColor, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, clearColor, RAPaint, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RASceneList_useClips arginfo_class_RADraw_evenOdd

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_setUseClips, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, useClips, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RASceneList_useCurves arginfo_class_RADraw_evenOdd

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_setUseCurves, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, useCurves, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RASceneList_showOpaques arginfo_class_RADraw_evenOdd

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_setShowOpaques, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, showOpaques, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

#define arginfo_class_RASceneList_showOutlines arginfo_class_RADraw_evenOdd

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_setShowOutlines, 0, 1, IS_VOID, 0)
	ZEND_ARG_TYPE_INFO(0, showOutlines, _IS_BOOL, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_addList, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, list, RASceneList, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_addScene, 0, 1, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, scene, RAScene, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_RASceneList_addSceneCtmClip, 0, 3, IS_VOID, 0)
	ZEND_ARG_OBJ_INFO(0, scene, RAScene, 0)
	ZEND_ARG_OBJ_INFO(0, ctm, CGAffineTransform, 0)
	ZEND_ARG_OBJ_INFO(0, clip, NSRect, 0)
ZEND_END_ARG_INFO()

ZEND_METHOD(CGAffineTransform, __construct);
ZEND_METHOD(RAPaint, init);
ZEND_METHOD(RAPaint, initWithGrayAlpha);
ZEND_METHOD(RAPaint, initWithHueSaturationValueAlpha);
ZEND_METHOD(RAPaint, initWithRedGreenBlueAlpha);
ZEND_METHOD(RAPaint, initWithCGColor);
ZEND_METHOD(RAPaint, initLinearLocationsStartEnd);
ZEND_METHOD(RAPaint, initRadialLocationsCenterRadius);
ZEND_METHOD(RAPaint, initWithCGImage);
ZEND_METHOD(RAPath, init);
ZEND_METHOD(RAPath, bounds);
ZEND_METHOD(RAPath, initWithCGPath);
ZEND_METHOD(RAPath, initWithRect);
ZEND_METHOD(RAPath, initWithEllipse);
ZEND_METHOD(RAPath, initWithRoundedRectCornerWidthCornerHeight);
ZEND_METHOD(RAPath, moveToY);
ZEND_METHOD(RAPath, lineToY);
ZEND_METHOD(RAPath, quadToY1X2Y2);
ZEND_METHOD(RAPath, cubicToY1X2Y2X3Y3);
ZEND_METHOD(RAPath, close);
ZEND_METHOD(RAPath, addCGPath);
ZEND_METHOD(RAPath, addRect);
ZEND_METHOD(RAPath, addEllipse);
ZEND_METHOD(RAPath, addRoundedRectCornerWidthCornerHeight);
ZEND_METHOD(RAPath, dashedCopyWithPhaseLengths);
ZEND_METHOD(RADraw, init);
ZEND_METHOD(RADraw, initWithPathCtmColor);
ZEND_METHOD(RADraw, path);
ZEND_METHOD(RADraw, setPath);
ZEND_METHOD(RADraw, ctm);
ZEND_METHOD(RADraw, setCtm);
ZEND_METHOD(RADraw, color);
ZEND_METHOD(RADraw, setColor);
ZEND_METHOD(RADraw, width);
ZEND_METHOD(RADraw, setWidth);
ZEND_METHOD(RADraw, evenOdd);
ZEND_METHOD(RADraw, setEvenOdd);
ZEND_METHOD(RADraw, capStyle);
ZEND_METHOD(RADraw, setCapStyle);
ZEND_METHOD(RADraw, joinStyle);
ZEND_METHOD(RADraw, setJoinStyle);
ZEND_METHOD(RADraw, clip);
ZEND_METHOD(RADraw, setClip);
ZEND_METHOD(RADraw, clipPath);
ZEND_METHOD(RADraw, setClipPath);
ZEND_METHOD(RADraw, clipEvenOdd);
ZEND_METHOD(RADraw, setClipEvenOdd);
ZEND_METHOD(RADraw, hidden);
ZEND_METHOD(RADraw, setHidden);
ZEND_METHOD(RADraw, blendMode);
ZEND_METHOD(RADraw, setBlendMode);
ZEND_METHOD(RAScene, init);
ZEND_METHOD(RAScene, bounds);
ZEND_METHOD(RAScene, count);
ZEND_METHOD(RAScene, addDraw);
ZEND_METHOD(RAScene, addImageCtm);
ZEND_METHOD(RAScene, addFillCtmColorEvenOddClipClipPathBlendMode);
ZEND_METHOD(RAScene, addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode);
ZEND_METHOD(RAScene, addTextInRectCtmClip);
ZEND_METHOD(RAScene, pdfPageCountFromUrl);
ZEND_METHOD(RAScene, addPdfFromUrlPageIndex);
ZEND_METHOD(RAScene, addSvgFromUrl);
ZEND_METHOD(RAScene, updateDrawsInRangeUsingBlock);
ZEND_METHOD(RASceneList, init);
ZEND_METHOD(RASceneList, initWithScene);
ZEND_METHOD(RASceneList, bounds);
ZEND_METHOD(RASceneList, ctm);
ZEND_METHOD(RASceneList, setCtm);
ZEND_METHOD(RASceneList, clearColor);
ZEND_METHOD(RASceneList, setClearColor);
ZEND_METHOD(RASceneList, useClips);
ZEND_METHOD(RASceneList, setUseClips);
ZEND_METHOD(RASceneList, useCurves);
ZEND_METHOD(RASceneList, setUseCurves);
ZEND_METHOD(RASceneList, showOpaques);
ZEND_METHOD(RASceneList, setShowOpaques);
ZEND_METHOD(RASceneList, showOutlines);
ZEND_METHOD(RASceneList, setShowOutlines);
ZEND_METHOD(RASceneList, addList);
ZEND_METHOD(RASceneList, addScene);
ZEND_METHOD(RASceneList, addSceneCtmClip);

static const zend_function_entry class_CGAffineTransform_methods[] = {
	ZEND_ME(CGAffineTransform, __construct, arginfo_class_CGAffineTransform___construct, ZEND_ACC_PUBLIC)
	ZEND_FE_END
};

static const zend_function_entry class_RAPaint_methods[] = {
	ZEND_ME(RAPaint, init, arginfo_class_RAPaint_init, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPaint, initWithGrayAlpha, arginfo_class_RAPaint_initWithGrayAlpha, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPaint, initWithHueSaturationValueAlpha, arginfo_class_RAPaint_initWithHueSaturationValueAlpha, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPaint, initWithRedGreenBlueAlpha, arginfo_class_RAPaint_initWithRedGreenBlueAlpha, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPaint, initWithCGColor, arginfo_class_RAPaint_initWithCGColor, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPaint, initLinearLocationsStartEnd, arginfo_class_RAPaint_initLinearLocationsStartEnd, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPaint, initRadialLocationsCenterRadius, arginfo_class_RAPaint_initRadialLocationsCenterRadius, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPaint, initWithCGImage, arginfo_class_RAPaint_initWithCGImage, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_FE_END
};

static const zend_function_entry class_RAPath_methods[] = {
	ZEND_ME(RAPath, init, arginfo_class_RAPath_init, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPath, bounds, arginfo_class_RAPath_bounds, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, initWithCGPath, arginfo_class_RAPath_initWithCGPath, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPath, initWithRect, arginfo_class_RAPath_initWithRect, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPath, initWithEllipse, arginfo_class_RAPath_initWithEllipse, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPath, initWithRoundedRectCornerWidthCornerHeight, arginfo_class_RAPath_initWithRoundedRectCornerWidthCornerHeight, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAPath, moveToY, arginfo_class_RAPath_moveToY, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, lineToY, arginfo_class_RAPath_lineToY, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, quadToY1X2Y2, arginfo_class_RAPath_quadToY1X2Y2, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, cubicToY1X2Y2X3Y3, arginfo_class_RAPath_cubicToY1X2Y2X3Y3, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, close, arginfo_class_RAPath_close, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, addCGPath, arginfo_class_RAPath_addCGPath, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, addRect, arginfo_class_RAPath_addRect, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, addEllipse, arginfo_class_RAPath_addEllipse, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, addRoundedRectCornerWidthCornerHeight, arginfo_class_RAPath_addRoundedRectCornerWidthCornerHeight, ZEND_ACC_PUBLIC)
	ZEND_ME(RAPath, dashedCopyWithPhaseLengths, arginfo_class_RAPath_dashedCopyWithPhaseLengths, ZEND_ACC_PUBLIC)
	ZEND_FE_END
};

static const zend_function_entry class_RADraw_methods[] = {
	ZEND_ME(RADraw, init, arginfo_class_RADraw_init, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RADraw, initWithPathCtmColor, arginfo_class_RADraw_initWithPathCtmColor, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RADraw, path, arginfo_class_RADraw_path, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setPath, arginfo_class_RADraw_setPath, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, ctm, arginfo_class_RADraw_ctm, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setCtm, arginfo_class_RADraw_setCtm, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, color, arginfo_class_RADraw_color, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setColor, arginfo_class_RADraw_setColor, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, width, arginfo_class_RADraw_width, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setWidth, arginfo_class_RADraw_setWidth, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, evenOdd, arginfo_class_RADraw_evenOdd, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setEvenOdd, arginfo_class_RADraw_setEvenOdd, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, capStyle, arginfo_class_RADraw_capStyle, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setCapStyle, arginfo_class_RADraw_setCapStyle, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, joinStyle, arginfo_class_RADraw_joinStyle, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setJoinStyle, arginfo_class_RADraw_setJoinStyle, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, clip, arginfo_class_RADraw_clip, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setClip, arginfo_class_RADraw_setClip, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, clipPath, arginfo_class_RADraw_clipPath, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setClipPath, arginfo_class_RADraw_setClipPath, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, clipEvenOdd, arginfo_class_RADraw_clipEvenOdd, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setClipEvenOdd, arginfo_class_RADraw_setClipEvenOdd, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, hidden, arginfo_class_RADraw_hidden, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setHidden, arginfo_class_RADraw_setHidden, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, blendMode, arginfo_class_RADraw_blendMode, ZEND_ACC_PUBLIC)
	ZEND_ME(RADraw, setBlendMode, arginfo_class_RADraw_setBlendMode, ZEND_ACC_PUBLIC)
	ZEND_FE_END
};

static const zend_function_entry class_RAScene_methods[] = {
	ZEND_ME(RAScene, init, arginfo_class_RAScene_init, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAScene, bounds, arginfo_class_RAScene_bounds, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, count, arginfo_class_RAScene_count, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, addDraw, arginfo_class_RAScene_addDraw, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, addImageCtm, arginfo_class_RAScene_addImageCtm, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, addFillCtmColorEvenOddClipClipPathBlendMode, arginfo_class_RAScene_addFillCtmColorEvenOddClipClipPathBlendMode, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode, arginfo_class_RAScene_addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, addTextInRectCtmClip, arginfo_class_RAScene_addTextInRectCtmClip, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, pdfPageCountFromUrl, arginfo_class_RAScene_pdfPageCountFromUrl, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RAScene, addPdfFromUrlPageIndex, arginfo_class_RAScene_addPdfFromUrlPageIndex, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, addSvgFromUrl, arginfo_class_RAScene_addSvgFromUrl, ZEND_ACC_PUBLIC)
	ZEND_ME(RAScene, updateDrawsInRangeUsingBlock, arginfo_class_RAScene_updateDrawsInRangeUsingBlock, ZEND_ACC_PUBLIC)
	ZEND_FE_END
};

static const zend_function_entry class_RASceneList_methods[] = {
	ZEND_ME(RASceneList, init, arginfo_class_RASceneList_init, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RASceneList, initWithScene, arginfo_class_RASceneList_initWithScene, ZEND_ACC_PUBLIC|ZEND_ACC_STATIC)
	ZEND_ME(RASceneList, bounds, arginfo_class_RASceneList_bounds, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, ctm, arginfo_class_RASceneList_ctm, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, setCtm, arginfo_class_RASceneList_setCtm, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, clearColor, arginfo_class_RASceneList_clearColor, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, setClearColor, arginfo_class_RASceneList_setClearColor, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, useClips, arginfo_class_RASceneList_useClips, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, setUseClips, arginfo_class_RASceneList_setUseClips, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, useCurves, arginfo_class_RASceneList_useCurves, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, setUseCurves, arginfo_class_RASceneList_setUseCurves, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, showOpaques, arginfo_class_RASceneList_showOpaques, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, setShowOpaques, arginfo_class_RASceneList_setShowOpaques, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, showOutlines, arginfo_class_RASceneList_showOutlines, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, setShowOutlines, arginfo_class_RASceneList_setShowOutlines, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, addList, arginfo_class_RASceneList_addList, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, addScene, arginfo_class_RASceneList_addScene, ZEND_ACC_PUBLIC)
	ZEND_ME(RASceneList, addSceneCtmClip, arginfo_class_RASceneList_addSceneCtmClip, ZEND_ACC_PUBLIC)
	ZEND_FE_END
};

static zend_class_entry *register_class_RACapStyle(void)
{
	zend_class_entry *class_entry = zend_register_internal_enum("RACapStyle", IS_LONG, NULL);

	zval enum_case_BUTT_value;
	ZVAL_LONG(&enum_case_BUTT_value, 0);
	zend_enum_add_case_cstr(class_entry, "BUTT", &enum_case_BUTT_value);

	zval enum_case_SQUARE_value;
	ZVAL_LONG(&enum_case_SQUARE_value, 1);
	zend_enum_add_case_cstr(class_entry, "SQUARE", &enum_case_SQUARE_value);

	zval enum_case_ROUND_value;
	ZVAL_LONG(&enum_case_ROUND_value, 2);
	zend_enum_add_case_cstr(class_entry, "ROUND", &enum_case_ROUND_value);

	return class_entry;
}

static zend_class_entry *register_class_RAJoinStyle(void)
{
	zend_class_entry *class_entry = zend_register_internal_enum("RAJoinStyle", IS_LONG, NULL);

	zval enum_case_MITER_value;
	ZVAL_LONG(&enum_case_MITER_value, 0);
	zend_enum_add_case_cstr(class_entry, "MITER", &enum_case_MITER_value);

	zval enum_case_ROUND_value;
	ZVAL_LONG(&enum_case_ROUND_value, 1);
	zend_enum_add_case_cstr(class_entry, "ROUND", &enum_case_ROUND_value);

	return class_entry;
}

static zend_class_entry *register_class_RABlendMode(void)
{
	zend_class_entry *class_entry = zend_register_internal_enum("RABlendMode", IS_LONG, NULL);

	zval enum_case_NORMAL_value;
	ZVAL_LONG(&enum_case_NORMAL_value, 0);
	zend_enum_add_case_cstr(class_entry, "NORMAL", &enum_case_NORMAL_value);

	zval enum_case_MULTIPLY_value;
	ZVAL_LONG(&enum_case_MULTIPLY_value, 1);
	zend_enum_add_case_cstr(class_entry, "MULTIPLY", &enum_case_MULTIPLY_value);

	zval enum_case_SCREEN_value;
	ZVAL_LONG(&enum_case_SCREEN_value, 2);
	zend_enum_add_case_cstr(class_entry, "SCREEN", &enum_case_SCREEN_value);

	zval enum_case_OVERLAY_value;
	ZVAL_LONG(&enum_case_OVERLAY_value, 3);
	zend_enum_add_case_cstr(class_entry, "OVERLAY", &enum_case_OVERLAY_value);

	zval enum_case_DARKEN_value;
	ZVAL_LONG(&enum_case_DARKEN_value, 4);
	zend_enum_add_case_cstr(class_entry, "DARKEN", &enum_case_DARKEN_value);

	zval enum_case_LIGHTEN_value;
	ZVAL_LONG(&enum_case_LIGHTEN_value, 5);
	zend_enum_add_case_cstr(class_entry, "LIGHTEN", &enum_case_LIGHTEN_value);

	zval enum_case_COLOR_DODGE_value;
	ZVAL_LONG(&enum_case_COLOR_DODGE_value, 6);
	zend_enum_add_case_cstr(class_entry, "COLOR_DODGE", &enum_case_COLOR_DODGE_value);

	zval enum_case_COLOR_BURN_value;
	ZVAL_LONG(&enum_case_COLOR_BURN_value, 7);
	zend_enum_add_case_cstr(class_entry, "COLOR_BURN", &enum_case_COLOR_BURN_value);

	zval enum_case_SOFT_LIGHT_value;
	ZVAL_LONG(&enum_case_SOFT_LIGHT_value, 8);
	zend_enum_add_case_cstr(class_entry, "SOFT_LIGHT", &enum_case_SOFT_LIGHT_value);

	zval enum_case_HARD_LIGHT_value;
	ZVAL_LONG(&enum_case_HARD_LIGHT_value, 9);
	zend_enum_add_case_cstr(class_entry, "HARD_LIGHT", &enum_case_HARD_LIGHT_value);

	zval enum_case_DIFFERENCE_value;
	ZVAL_LONG(&enum_case_DIFFERENCE_value, 10);
	zend_enum_add_case_cstr(class_entry, "DIFFERENCE", &enum_case_DIFFERENCE_value);

	zval enum_case_EXCLUSION_value;
	ZVAL_LONG(&enum_case_EXCLUSION_value, 11);
	zend_enum_add_case_cstr(class_entry, "EXCLUSION", &enum_case_EXCLUSION_value);

	zval enum_case_HUE_value;
	ZVAL_LONG(&enum_case_HUE_value, 12);
	zend_enum_add_case_cstr(class_entry, "HUE", &enum_case_HUE_value);

	zval enum_case_SATURATION_value;
	ZVAL_LONG(&enum_case_SATURATION_value, 13);
	zend_enum_add_case_cstr(class_entry, "SATURATION", &enum_case_SATURATION_value);

	zval enum_case_COLOR_value;
	ZVAL_LONG(&enum_case_COLOR_value, 14);
	zend_enum_add_case_cstr(class_entry, "COLOR", &enum_case_COLOR_value);

	zval enum_case_LUMINOSITY_value;
	ZVAL_LONG(&enum_case_LUMINOSITY_value, 15);
	zend_enum_add_case_cstr(class_entry, "LUMINOSITY", &enum_case_LUMINOSITY_value);

	return class_entry;
}

static zend_class_entry *register_class_CGAffineTransform(void)
{
	zend_class_entry ce, *class_entry;

	INIT_CLASS_ENTRY(ce, "CGAffineTransform", class_CGAffineTransform_methods);
	class_entry = zend_register_internal_class_with_flags(&ce, NULL, ZEND_ACC_FINAL|ZEND_ACC_NOT_SERIALIZABLE);

	zval property_a_default_value;
	ZVAL_UNDEF(&property_a_default_value);
	zend_string *property_a_name = zend_string_init("a", sizeof("a") - 1, 1);
	zend_declare_typed_property(class_entry, property_a_name, &property_a_default_value, ZEND_ACC_PUBLIC, NULL, (zend_type) ZEND_TYPE_INIT_MASK(MAY_BE_DOUBLE));
	zend_string_release(property_a_name);

	zval property_b_default_value;
	ZVAL_UNDEF(&property_b_default_value);
	zend_string *property_b_name = zend_string_init("b", sizeof("b") - 1, 1);
	zend_declare_typed_property(class_entry, property_b_name, &property_b_default_value, ZEND_ACC_PUBLIC, NULL, (zend_type) ZEND_TYPE_INIT_MASK(MAY_BE_DOUBLE));
	zend_string_release(property_b_name);

	zval property_c_default_value;
	ZVAL_UNDEF(&property_c_default_value);
	zend_string *property_c_name = zend_string_init("c", sizeof("c") - 1, 1);
	zend_declare_typed_property(class_entry, property_c_name, &property_c_default_value, ZEND_ACC_PUBLIC, NULL, (zend_type) ZEND_TYPE_INIT_MASK(MAY_BE_DOUBLE));
	zend_string_release(property_c_name);

	zval property_d_default_value;
	ZVAL_UNDEF(&property_d_default_value);
	zend_string *property_d_name = zend_string_init("d", sizeof("d") - 1, 1);
	zend_declare_typed_property(class_entry, property_d_name, &property_d_default_value, ZEND_ACC_PUBLIC, NULL, (zend_type) ZEND_TYPE_INIT_MASK(MAY_BE_DOUBLE));
	zend_string_release(property_d_name);

	zval property_tx_default_value;
	ZVAL_UNDEF(&property_tx_default_value);
	zend_string *property_tx_name = zend_string_init("tx", sizeof("tx") - 1, 1);
	zend_declare_typed_property(class_entry, property_tx_name, &property_tx_default_value, ZEND_ACC_PUBLIC, NULL, (zend_type) ZEND_TYPE_INIT_MASK(MAY_BE_DOUBLE));
	zend_string_release(property_tx_name);

	zval property_ty_default_value;
	ZVAL_UNDEF(&property_ty_default_value);
	zend_string *property_ty_name = zend_string_init("ty", sizeof("ty") - 1, 1);
	zend_declare_typed_property(class_entry, property_ty_name, &property_ty_default_value, ZEND_ACC_PUBLIC, NULL, (zend_type) ZEND_TYPE_INIT_MASK(MAY_BE_DOUBLE));
	zend_string_release(property_ty_name);

	return class_entry;
}

static zend_class_entry *register_class_RAPaint(zend_class_entry *class_entry_NSObject)
{
	zend_class_entry ce, *class_entry;

	INIT_CLASS_ENTRY(ce, "RAPaint", class_RAPaint_methods);
	class_entry = zend_register_internal_class_with_flags(&ce, class_entry_NSObject, ZEND_ACC_NOT_SERIALIZABLE);

	return class_entry;
}

static zend_class_entry *register_class_RAPath(zend_class_entry *class_entry_NSObject)
{
	zend_class_entry ce, *class_entry;

	INIT_CLASS_ENTRY(ce, "RAPath", class_RAPath_methods);
	class_entry = zend_register_internal_class_with_flags(&ce, class_entry_NSObject, ZEND_ACC_NOT_SERIALIZABLE);

	return class_entry;
}

static zend_class_entry *register_class_RADraw(zend_class_entry *class_entry_NSObject)
{
	zend_class_entry ce, *class_entry;

	INIT_CLASS_ENTRY(ce, "RADraw", class_RADraw_methods);
	class_entry = zend_register_internal_class_with_flags(&ce, class_entry_NSObject, ZEND_ACC_NOT_SERIALIZABLE);

	return class_entry;
}

static zend_class_entry *register_class_RAScene(zend_class_entry *class_entry_NSObject)
{
	zend_class_entry ce, *class_entry;

	INIT_CLASS_ENTRY(ce, "RAScene", class_RAScene_methods);
	class_entry = zend_register_internal_class_with_flags(&ce, class_entry_NSObject, ZEND_ACC_NOT_SERIALIZABLE);

	return class_entry;
}

static zend_class_entry *register_class_RASceneList(zend_class_entry *class_entry_NSObject)
{
	zend_class_entry ce, *class_entry;

	INIT_CLASS_ENTRY(ce, "RASceneList", class_RASceneList_methods);
	class_entry = zend_register_internal_class_with_flags(&ce, class_entry_NSObject, ZEND_ACC_NOT_SERIALIZABLE);

	return class_entry;
}
