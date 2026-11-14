#include "runtime.h"
#include "../stubs/RasterizerAPI_arginfo.h"

_Static_assert(kCapButt == 0 && kCapSquare == 1 && kCapRound == 2, "RACapStyle values moved");
_Static_assert(kJoinMiter == 0 && kJoinRound == 1, "RAJoinStyle values moved");
_Static_assert(kRABlendNormal == 0 && kRABlendMultiply == 1 && kRABlendScreen == 2 && kRABlendOverlay == 3
	&& kRABlendDarken == 4 && kRABlendLighten == 5 && kRABlendColorDodge == 6 && kRABlendColorBurn == 7
	&& kRABlendSoftLight == 8 && kRABlendHardLight == 9 && kRABlendDifference == 10 && kRABlendExclusion == 11
	&& kRABlendHue == 12 && kRABlendSaturation == 13 && kRABlendColor == 14 && kRABlendLuminosity == 15,
	"RABlendMode values moved");

zend_class_entry *mindbrix_ce_RACapStyle;
zend_class_entry *mindbrix_ce_RAJoinStyle;
zend_class_entry *mindbrix_ce_RABlendMode;
zend_class_entry *mindbrix_ce_CGAffineTransform;
zend_class_entry *mindbrix_ce_RAPaint;
zend_class_entry *mindbrix_ce_RAPath;
zend_class_entry *mindbrix_ce_RADraw;
zend_class_entry *mindbrix_ce_RAScene;
zend_class_entry *mindbrix_ce_RASceneList;

#define THIS_ID APPKIT_ID(Z_OBJ_P(ZEND_THIS))

void mindbrix_register_RasterizerAPI(int module_number)
{
	mindbrix_ce_RACapStyle = register_class_RACapStyle();
	mindbrix_ce_RAJoinStyle = register_class_RAJoinStyle();
	mindbrix_ce_RABlendMode = register_class_RABlendMode();
	mindbrix_ce_CGAffineTransform = register_class_CGAffineTransform();

	mindbrix_ce_RAPaint = register_class_RAPaint(appkit_ce_NSObject);
	appkit_object_setup(mindbrix_ce_RAPaint);
	appkit_map_objc_class("RAPaint", mindbrix_ce_RAPaint);

	mindbrix_ce_RAPath = register_class_RAPath(appkit_ce_NSObject);
	appkit_object_setup(mindbrix_ce_RAPath);
	appkit_map_objc_class("RAPath", mindbrix_ce_RAPath);

	mindbrix_ce_RADraw = register_class_RADraw(appkit_ce_NSObject);
	appkit_object_setup(mindbrix_ce_RADraw);
	appkit_map_objc_class("RADraw", mindbrix_ce_RADraw);

	mindbrix_ce_RAScene = register_class_RAScene(appkit_ce_NSObject);
	appkit_object_setup(mindbrix_ce_RAScene);
	appkit_map_objc_class("RAScene", mindbrix_ce_RAScene);

	mindbrix_ce_RASceneList = register_class_RASceneList(appkit_ce_NSObject);
	appkit_object_setup(mindbrix_ce_RASceneList);
	appkit_map_objc_class("RASceneList", mindbrix_ce_RASceneList);
}

/* ---- values ---------------------------------------------------------------------------- */

/* CGAffineTransform from the value class: properties 0..5 = a b c d tx ty. ValueError for an unset one. */
static bool mindbrix_transform_from(zend_object *obj, uint32_t arg_num, CGAffineTransform *out)
{
	double v[6];

	for (int i = 0; i < 6; i++) {
		zval *prop = OBJ_PROP_NUM(obj, i);

		if (Z_TYPE_P(prop) != IS_DOUBLE) {
			zend_argument_value_error(arg_num, "must have every property initialized");
			return false;
		}
		v[i] = Z_DVAL_P(prop);
		if (!isfinite(v[i])) {
			zend_argument_value_error(arg_num, "must have finite properties");
			return false;
		}
	}
	*out = CGAffineTransformMake(v[0], v[1], v[2], v[3], v[4], v[5]);
	return true;
}

/*
 * Geometry Rasterizer subdivides must be finite. Its curve writers count subdivisions in a float
 * (GeometryWriter::Cubic and ::Quadratic, looping while (--count)); INF or NaN geometry makes a
 * count that never reaches 0, so the display drawing it never returns and memory grows until the
 * process is killed. lib/Rasterizer carries a fix for the loop (design spec, "Curve subdivision");
 * the binding also refuses non-finite geometry, so it holds against an unpatched Rasterizer.
 * Clip rects are not checked: CGRectNull (infinite origin) is how a caller asks for no clip.
 */
static bool mindbrix_finite(uint32_t arg_num, double v)
{
	if (isfinite(v)) {
		return true;
	}
	zend_argument_value_error(arg_num, "must be finite");
	return false;
}

static bool mindbrix_finite_rect(uint32_t arg_num, NSRect r)
{
	if (isfinite(r.origin.x) && isfinite(r.origin.y) && isfinite(r.size.width) && isfinite(r.size.height)) {
		return true;
	}
	zend_argument_value_error(arg_num, "must have finite properties");
	return false;
}

static void mindbrix_return_transform(zval *rv, CGAffineTransform t)
{
	object_init_ex(rv, mindbrix_ce_CGAffineTransform);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(rv), 0), t.a);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(rv), 1), t.b);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(rv), 2), t.c);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(rv), 3), t.d);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(rv), 4), t.tx);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(rv), 5), t.ty);
}

/* NSArray<NSNumber *> from a PHP array of ints and floats (autoreleased); nil with a TypeError for anything else. */
static NSArray *mindbrix_number_array(HashTable *ht, uint32_t arg_num)
{
	NSMutableArray *numbers = [NSMutableArray arrayWithCapacity:zend_hash_num_elements(ht)];
	zval *value;

	ZEND_HASH_FOREACH_VAL(ht, value) {
		ZVAL_DEREF(value);
		if (Z_TYPE_P(value) == IS_LONG) {
			[numbers addObject:[NSNumber numberWithDouble:(double) Z_LVAL_P(value)]];
		} else if (Z_TYPE_P(value) == IS_DOUBLE) {
			[numbers addObject:[NSNumber numberWithDouble:Z_DVAL_P(value)]];
		} else {
			zend_argument_type_error(arg_num, "must contain only int or float values, %s given", zend_zval_value_name(value));
			return nil;
		}
	} ZEND_HASH_FOREACH_END();

	return numbers;
}

/* The CGPathRef a CFType wraps; NULL with a TypeError when it wraps another CF type. */
static CGPathRef mindbrix_cgpath_from(zend_object *obj, uint32_t arg_num)
{
	CFTypeRef ref = APPKIT_CF(obj);

	if (ref == NULL || CFGetTypeID(ref) != CGPathGetTypeID()) {
		zend_argument_type_error(arg_num, "must wrap a CGPathRef");
		return NULL;
	}
	return (CGPathRef) ref;
}

/* ---- CGAffineTransform ----------------------------------------------------------------- */

ZEND_METHOD(CGAffineTransform, __construct)
{
	double a, b, c, d, tx, ty;

	ZEND_PARSE_PARAMETERS_START(6, 6)
		Z_PARAM_DOUBLE(a)
		Z_PARAM_DOUBLE(b)
		Z_PARAM_DOUBLE(c)
		Z_PARAM_DOUBLE(d)
		Z_PARAM_DOUBLE(tx)
		Z_PARAM_DOUBLE(ty)
	ZEND_PARSE_PARAMETERS_END();

	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(ZEND_THIS), 0), a);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(ZEND_THIS), 1), b);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(ZEND_THIS), 2), c);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(ZEND_THIS), 3), d);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(ZEND_THIS), 4), tx);
	ZVAL_DOUBLE(OBJ_PROP_NUM(Z_OBJ_P(ZEND_THIS), 5), ty);
}

/* ---- RAPaint --------------------------------------------------------------------------- */

ZEND_METHOD(RAPaint, init)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RAPaint *made = [[CALLED alloc] init];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPaint, initWithGrayAlpha)
{
	double gray, alpha;

	ZEND_PARSE_PARAMETERS_START(2, 2)
		Z_PARAM_DOUBLE(gray)
		Z_PARAM_DOUBLE(alpha)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		RAPaint *made = [[CALLED alloc] initWithGray:gray alpha:alpha];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPaint, initWithHueSaturationValueAlpha)
{
	double hue, saturation, value, alpha;

	ZEND_PARSE_PARAMETERS_START(4, 4)
		Z_PARAM_DOUBLE(hue)
		Z_PARAM_DOUBLE(saturation)
		Z_PARAM_DOUBLE(value)
		Z_PARAM_DOUBLE(alpha)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		RAPaint *made = [[CALLED alloc] initWithHue:hue saturation:saturation value:value alpha:alpha];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPaint, initWithRedGreenBlueAlpha)
{
	double red, green, blue, alpha;

	ZEND_PARSE_PARAMETERS_START(4, 4)
		Z_PARAM_DOUBLE(red)
		Z_PARAM_DOUBLE(green)
		Z_PARAM_DOUBLE(blue)
		Z_PARAM_DOUBLE(alpha)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		RAPaint *made = [[CALLED alloc] initWithRed:red green:green blue:blue alpha:alpha];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPaint, initWithCGColor)
{
	zend_object *color;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(color, appkit_ce_CGColor)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		RAPaint *made = [[CALLED alloc] initWithCGColor:(CGColorRef) APPKIT_CF(color)];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPaint, initLinearLocationsStartEnd)
{
	HashTable *colors, *locations;
	zend_object *start, *end;
	NSPoint s, e;

	ZEND_PARSE_PARAMETERS_START(4, 4)
		Z_PARAM_ARRAY_HT(colors)
		Z_PARAM_ARRAY_HT(locations)
		Z_PARAM_OBJ_OF_CLASS(start, appkit_ce_NSPoint)
		Z_PARAM_OBJ_OF_CLASS(end, appkit_ce_NSPoint)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_point_from(start, 3, &s) || !appkit_point_from(end, 4, &e)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		NSArray *paints = appkit_object_array(colors, mindbrix_ce_RAPaint, 1);
		if (paints == nil) {
			RETURN_THROWS();
		}
		NSArray *numbers = mindbrix_number_array(locations, 2);
		if (numbers == nil) {
			RETURN_THROWS();
		}
		RAPaint *made = [[CALLED alloc] initLinear:paints locations:numbers start:s end:e];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPaint, initRadialLocationsCenterRadius)
{
	HashTable *colors, *locations;
	zend_object *center;
	double radius;
	NSPoint c;

	ZEND_PARSE_PARAMETERS_START(4, 4)
		Z_PARAM_ARRAY_HT(colors)
		Z_PARAM_ARRAY_HT(locations)
		Z_PARAM_OBJ_OF_CLASS(center, appkit_ce_NSPoint)
		Z_PARAM_DOUBLE(radius)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_point_from(center, 3, &c)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		NSArray *paints = appkit_object_array(colors, mindbrix_ce_RAPaint, 1);
		if (paints == nil) {
			RETURN_THROWS();
		}
		NSArray *numbers = mindbrix_number_array(locations, 2);
		if (numbers == nil) {
			RETURN_THROWS();
		}
		RAPaint *made = [[CALLED alloc] initRadial:paints locations:numbers center:c radius:radius];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPaint, initWithCGImage)
{
	zend_object *image;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(image, appkit_ce_CGImage)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		RAPaint *made = [[CALLED alloc] initWithCGImage:(CGImageRef) APPKIT_CF(image)];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

/* ---- RAPath ---------------------------------------------------------------------------- */

ZEND_METHOD(RAPath, init)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RAPath *made = [[CALLED alloc] init];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPath, bounds)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_return_rect(return_value, [(RAPath *) THIS_ID bounds]);
	APPKIT_END
}

ZEND_METHOD(RAPath, initWithCGPath)
{
	zend_object *path;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(path, appkit_ce_CFType)
	ZEND_PARSE_PARAMETERS_END();
	CGPathRef cg = mindbrix_cgpath_from(path, 1);
	if (cg == NULL) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		RAPath *made = [[CALLED alloc] initWithCGPath:cg];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPath, initWithRect)
{
	zend_object *rect;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(rect, appkit_ce_NSRect)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_rect_from(rect, 1, &r) || !mindbrix_finite_rect(1, r)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		RAPath *made = [[CALLED alloc] initWithRect:r];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPath, initWithEllipse)
{
	zend_object *rect;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(rect, appkit_ce_NSRect)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_rect_from(rect, 1, &r) || !mindbrix_finite_rect(1, r)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		RAPath *made = [[CALLED alloc] initWithEllipse:r];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPath, initWithRoundedRectCornerWidthCornerHeight)
{
	zend_object *rect;
	double cornerWidth, cornerHeight;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(3, 3)
		Z_PARAM_OBJ_OF_CLASS(rect, appkit_ce_NSRect)
		Z_PARAM_DOUBLE(cornerWidth)
		Z_PARAM_DOUBLE(cornerHeight)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_rect_from(rect, 1, &r) || !mindbrix_finite_rect(1, r) || !mindbrix_finite(2, cornerWidth) || !mindbrix_finite(3, cornerHeight)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		RAPath *made = [[CALLED alloc] initWithRoundedRect:r cornerWidth:cornerWidth cornerHeight:cornerHeight];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAPath, moveToY)
{
	double x, y;

	ZEND_PARSE_PARAMETERS_START(2, 2)
		Z_PARAM_DOUBLE(x)
		Z_PARAM_DOUBLE(y)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_finite(1, x) || !mindbrix_finite(2, y)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAPath *) THIS_ID moveTo:x y:y];
	APPKIT_END
}

ZEND_METHOD(RAPath, lineToY)
{
	double x, y;

	ZEND_PARSE_PARAMETERS_START(2, 2)
		Z_PARAM_DOUBLE(x)
		Z_PARAM_DOUBLE(y)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_finite(1, x) || !mindbrix_finite(2, y)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAPath *) THIS_ID lineTo:x y:y];
	APPKIT_END
}

ZEND_METHOD(RAPath, quadToY1X2Y2)
{
	double x1, y1, x2, y2;

	ZEND_PARSE_PARAMETERS_START(4, 4)
		Z_PARAM_DOUBLE(x1)
		Z_PARAM_DOUBLE(y1)
		Z_PARAM_DOUBLE(x2)
		Z_PARAM_DOUBLE(y2)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_finite(1, x1) || !mindbrix_finite(2, y1) || !mindbrix_finite(3, x2) || !mindbrix_finite(4, y2)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAPath *) THIS_ID quadTo:x1 y1:y1 x2:x2 y2:y2];
	APPKIT_END
}

ZEND_METHOD(RAPath, cubicToY1X2Y2X3Y3)
{
	double x1, y1, x2, y2, x3, y3;

	ZEND_PARSE_PARAMETERS_START(6, 6)
		Z_PARAM_DOUBLE(x1)
		Z_PARAM_DOUBLE(y1)
		Z_PARAM_DOUBLE(x2)
		Z_PARAM_DOUBLE(y2)
		Z_PARAM_DOUBLE(x3)
		Z_PARAM_DOUBLE(y3)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_finite(1, x1) || !mindbrix_finite(2, y1) || !mindbrix_finite(3, x2) || !mindbrix_finite(4, y2)
		|| !mindbrix_finite(5, x3) || !mindbrix_finite(6, y3)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAPath *) THIS_ID cubicTo:x1 y1:y1 x2:x2 y2:y2 x3:x3 y3:y3];
	APPKIT_END
}

ZEND_METHOD(RAPath, close)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		[(RAPath *) THIS_ID close];
	APPKIT_END
}

ZEND_METHOD(RAPath, addCGPath)
{
	zend_object *path;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(path, appkit_ce_CFType)
	ZEND_PARSE_PARAMETERS_END();
	CGPathRef cg = mindbrix_cgpath_from(path, 1);
	if (cg == NULL) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAPath *) THIS_ID addCGPath:cg];
	APPKIT_END
}

ZEND_METHOD(RAPath, addRect)
{
	zend_object *rect;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(rect, appkit_ce_NSRect)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_rect_from(rect, 1, &r) || !mindbrix_finite_rect(1, r)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAPath *) THIS_ID addRect:r];
	APPKIT_END
}

ZEND_METHOD(RAPath, addEllipse)
{
	zend_object *rect;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(rect, appkit_ce_NSRect)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_rect_from(rect, 1, &r) || !mindbrix_finite_rect(1, r)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAPath *) THIS_ID addEllipse:r];
	APPKIT_END
}

ZEND_METHOD(RAPath, addRoundedRectCornerWidthCornerHeight)
{
	zend_object *rect;
	double cornerWidth, cornerHeight;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(3, 3)
		Z_PARAM_OBJ_OF_CLASS(rect, appkit_ce_NSRect)
		Z_PARAM_DOUBLE(cornerWidth)
		Z_PARAM_DOUBLE(cornerHeight)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_rect_from(rect, 1, &r) || !mindbrix_finite_rect(1, r) || !mindbrix_finite(2, cornerWidth) || !mindbrix_finite(3, cornerHeight)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAPath *) THIS_ID addRoundedRect:r cornerWidth:cornerWidth cornerHeight:cornerHeight];
	APPKIT_END
}

ZEND_METHOD(RAPath, dashedCopyWithPhaseLengths)
{
	double phase;
	HashTable *lengths;

	ZEND_PARSE_PARAMETERS_START(2, 2)
		Z_PARAM_DOUBLE(phase)
		Z_PARAM_ARRAY_HT(lengths)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_finite(1, phase)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		NSArray *numbers = mindbrix_number_array(lengths, 2);
		if (numbers == nil) {
			RETURN_THROWS();
		}
		for (NSNumber *length in numbers) {
			if (!isfinite([length doubleValue])) {
				zend_argument_value_error(2, "must contain only finite values");
				RETURN_THROWS();
			}
		}
		appkit_box_objc(return_value, [(RAPath *) THIS_ID dashedCopyWithPhase:phase lengths:numbers]);
	APPKIT_END
}

/* ---- RADraw ---------------------------------------------------------------------------- */

ZEND_METHOD(RADraw, init)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RADraw *made = [[CALLED alloc] init];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RADraw, initWithPathCtmColor)
{
	zend_object *path, *ctm, *color;
	CGAffineTransform t;

	ZEND_PARSE_PARAMETERS_START(3, 3)
		Z_PARAM_OBJ_OF_CLASS(path, mindbrix_ce_RAPath)
		Z_PARAM_OBJ_OF_CLASS(ctm, mindbrix_ce_CGAffineTransform)
		Z_PARAM_OBJ_OF_CLASS(color, mindbrix_ce_RAPaint)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_transform_from(ctm, 2, &t)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		RADraw *made = [[CALLED alloc] initWithPath:(RAPath *) APPKIT_ID(path) ctm:t color:(RAPaint *) APPKIT_ID(color)];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RADraw, path)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_box_objc(return_value, [(RADraw *) THIS_ID path]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setPath)
{
	zend_object *path;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(path, mindbrix_ce_RAPath)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setPath:(RAPath *) APPKIT_ID(path)];
	APPKIT_END
}

ZEND_METHOD(RADraw, ctm)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		mindbrix_return_transform(return_value, [(RADraw *) THIS_ID ctm]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setCtm)
{
	zend_object *ctm;
	CGAffineTransform t;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(ctm, mindbrix_ce_CGAffineTransform)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_transform_from(ctm, 1, &t)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setCtm:t];
	APPKIT_END
}

ZEND_METHOD(RADraw, color)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_box_objc(return_value, [(RADraw *) THIS_ID color]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setColor)
{
	zend_object *color;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(color, mindbrix_ce_RAPaint)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setColor:(RAPaint *) APPKIT_ID(color)];
	APPKIT_END
}

ZEND_METHOD(RADraw, width)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_DOUBLE([(RADraw *) THIS_ID width]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setWidth)
{
	double width;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_DOUBLE(width)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_finite(1, width)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setWidth:width];
	APPKIT_END
}

ZEND_METHOD(RADraw, evenOdd)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_BOOL([(RADraw *) THIS_ID evenOdd]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setEvenOdd)
{
	bool evenOdd;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_BOOL(evenOdd)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setEvenOdd:evenOdd];
	APPKIT_END
}

ZEND_METHOD(RADraw, capStyle)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_return_enum(return_value, mindbrix_ce_RACapStyle, (zend_long) [(RADraw *) THIS_ID capStyle], false);
	APPKIT_END
}

ZEND_METHOD(RADraw, setCapStyle)
{
	zend_object *capStyle;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(capStyle, mindbrix_ce_RACapStyle)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setCapStyle:(RACapStyle) appkit_enum_value(capStyle, 0)];
	APPKIT_END
}

ZEND_METHOD(RADraw, joinStyle)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_return_enum(return_value, mindbrix_ce_RAJoinStyle, (zend_long) [(RADraw *) THIS_ID joinStyle], false);
	APPKIT_END
}

ZEND_METHOD(RADraw, setJoinStyle)
{
	zend_object *joinStyle;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(joinStyle, mindbrix_ce_RAJoinStyle)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setJoinStyle:(RAJoinStyle) appkit_enum_value(joinStyle, 0)];
	APPKIT_END
}

ZEND_METHOD(RADraw, clip)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_return_rect(return_value, [(RADraw *) THIS_ID clip]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setClip)
{
	zend_object *clip;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(clip, appkit_ce_NSRect)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_rect_from(clip, 1, &r)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setClip:r];
	APPKIT_END
}

ZEND_METHOD(RADraw, clipPath)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_box_objc(return_value, [(RADraw *) THIS_ID clipPath]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setClipPath)
{
	zend_object *clipPath = NULL;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS_OR_NULL(clipPath, mindbrix_ce_RAPath)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setClipPath:clipPath != NULL ? (RAPath *) APPKIT_ID(clipPath) : nil];
	APPKIT_END
}

ZEND_METHOD(RADraw, clipEvenOdd)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_BOOL([(RADraw *) THIS_ID clipEvenOdd]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setClipEvenOdd)
{
	bool clipEvenOdd;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_BOOL(clipEvenOdd)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setClipEvenOdd:clipEvenOdd];
	APPKIT_END
}

ZEND_METHOD(RADraw, hidden)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_BOOL([(RADraw *) THIS_ID hidden]);
	APPKIT_END
}

ZEND_METHOD(RADraw, setHidden)
{
	bool hidden;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_BOOL(hidden)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setHidden:hidden];
	APPKIT_END
}

ZEND_METHOD(RADraw, blendMode)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_return_enum(return_value, mindbrix_ce_RABlendMode, (zend_long) [(RADraw *) THIS_ID blendMode], false);
	APPKIT_END
}

ZEND_METHOD(RADraw, setBlendMode)
{
	zend_object *blendMode;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(blendMode, mindbrix_ce_RABlendMode)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RADraw *) THIS_ID setBlendMode:(RABlendMode) appkit_enum_value(blendMode, 0)];
	APPKIT_END
}

/* ---- RAScene --------------------------------------------------------------------------- */

ZEND_METHOD(RAScene, init)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RAScene *made = [[CALLED alloc] init];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RAScene, bounds)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_return_rect(return_value, [(RAScene *) THIS_ID bounds]);
	APPKIT_END
}

ZEND_METHOD(RAScene, count)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_LONG((zend_long) [(RAScene *) THIS_ID count]);
	APPKIT_END
}

ZEND_METHOD(RAScene, addDraw)
{
	zend_object *draw;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(draw, mindbrix_ce_RADraw)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RAScene *) THIS_ID addDraw:(RADraw *) APPKIT_ID(draw)];
	APPKIT_END
}

ZEND_METHOD(RAScene, addImageCtm)
{
	zend_object *image, *ctm;
	CGAffineTransform t;

	ZEND_PARSE_PARAMETERS_START(2, 2)
		Z_PARAM_OBJ_OF_CLASS(image, mindbrix_ce_RAPaint)
		Z_PARAM_OBJ_OF_CLASS(ctm, mindbrix_ce_CGAffineTransform)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_transform_from(ctm, 2, &t)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAScene *) THIS_ID addImage:(RAPaint *) APPKIT_ID(image) ctm:t];
	APPKIT_END
}

ZEND_METHOD(RAScene, addFillCtmColorEvenOddClipClipPathBlendMode)
{
	zend_object *path, *ctm, *color, *clip, *clipPath = NULL, *blendMode;
	bool evenOdd;
	CGAffineTransform t;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(7, 7)
		Z_PARAM_OBJ_OF_CLASS(path, mindbrix_ce_RAPath)
		Z_PARAM_OBJ_OF_CLASS(ctm, mindbrix_ce_CGAffineTransform)
		Z_PARAM_OBJ_OF_CLASS(color, mindbrix_ce_RAPaint)
		Z_PARAM_BOOL(evenOdd)
		Z_PARAM_OBJ_OF_CLASS(clip, appkit_ce_NSRect)
		Z_PARAM_OBJ_OF_CLASS_OR_NULL(clipPath, mindbrix_ce_RAPath)
		Z_PARAM_OBJ_OF_CLASS(blendMode, mindbrix_ce_RABlendMode)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_transform_from(ctm, 2, &t) || !appkit_rect_from(clip, 5, &r)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAScene *) THIS_ID addFill:(RAPath *) APPKIT_ID(path)
			ctm:t
			color:(RAPaint *) APPKIT_ID(color)
			evenOdd:evenOdd
			clip:r
			clipPath:clipPath != NULL ? (RAPath *) APPKIT_ID(clipPath) : nil
			blendMode:(RABlendMode) appkit_enum_value(blendMode, 0)];
	APPKIT_END
}

ZEND_METHOD(RAScene, addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode)
{
	zend_object *path, *ctm, *color, *capStyle, *joinStyle, *clip, *clipPath = NULL, *blendMode;
	double width;
	CGAffineTransform t;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(9, 9)
		Z_PARAM_OBJ_OF_CLASS(path, mindbrix_ce_RAPath)
		Z_PARAM_OBJ_OF_CLASS(ctm, mindbrix_ce_CGAffineTransform)
		Z_PARAM_OBJ_OF_CLASS(color, mindbrix_ce_RAPaint)
		Z_PARAM_DOUBLE(width)
		Z_PARAM_OBJ_OF_CLASS(capStyle, mindbrix_ce_RACapStyle)
		Z_PARAM_OBJ_OF_CLASS(joinStyle, mindbrix_ce_RAJoinStyle)
		Z_PARAM_OBJ_OF_CLASS(clip, appkit_ce_NSRect)
		Z_PARAM_OBJ_OF_CLASS_OR_NULL(clipPath, mindbrix_ce_RAPath)
		Z_PARAM_OBJ_OF_CLASS(blendMode, mindbrix_ce_RABlendMode)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_transform_from(ctm, 2, &t) || !mindbrix_finite(4, width) || !appkit_rect_from(clip, 7, &r)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RAScene *) THIS_ID addStroke:(RAPath *) APPKIT_ID(path)
			ctm:t
			color:(RAPaint *) APPKIT_ID(color)
			width:width
			capStyle:(RACapStyle) appkit_enum_value(capStyle, 0)
			joinStyle:(RAJoinStyle) appkit_enum_value(joinStyle, 0)
			clip:r
			clipPath:clipPath != NULL ? (RAPath *) APPKIT_ID(clipPath) : nil
			blendMode:(RABlendMode) appkit_enum_value(blendMode, 0)];
	APPKIT_END
}

ZEND_METHOD(RAScene, addTextInRectCtmClip)
{
	zend_object *string, *rect, *ctm, *clip;
	NSRect r, c;
	CGAffineTransform t;

	ZEND_PARSE_PARAMETERS_START(4, 4)
		Z_PARAM_OBJ_OF_CLASS(string, appkit_ce_NSAttributedString)
		Z_PARAM_OBJ_OF_CLASS(rect, appkit_ce_NSRect)
		Z_PARAM_OBJ_OF_CLASS(ctm, mindbrix_ce_CGAffineTransform)
		Z_PARAM_OBJ_OF_CLASS(clip, appkit_ce_NSRect)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_rect_from(rect, 2, &r) || !mindbrix_transform_from(ctm, 3, &t) || !appkit_rect_from(clip, 4, &c)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		appkit_return_rect(return_value, [(RAScene *) THIS_ID addText:(NSAttributedString *) APPKIT_ID(string) inRect:r ctm:t clip:c]);
	APPKIT_END
}

ZEND_METHOD(RAScene, pdfPageCountFromUrl)
{
	zend_object *url;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(url, appkit_ce_NSURL)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		RETVAL_LONG((zend_long) [CALLED pdfPageCountFromUrl:(NSURL *) APPKIT_ID(url)]);
	APPKIT_END
}

ZEND_METHOD(RAScene, addPdfFromUrlPageIndex)
{
	zend_object *url;
	zend_long pageIndex;

	ZEND_PARSE_PARAMETERS_START(2, 2)
		Z_PARAM_OBJ_OF_CLASS(url, appkit_ce_NSURL)
		Z_PARAM_LONG(pageIndex)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		mindbrix_return_transform(return_value, [(RAScene *) THIS_ID addPdfFromUrl:(NSURL *) APPKIT_ID(url) pageIndex:(NSInteger) pageIndex]);
	APPKIT_END
}

ZEND_METHOD(RAScene, addSvgFromUrl)
{
	zend_object *url;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(url, appkit_ce_NSURL)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		mindbrix_return_transform(return_value, [(RAScene *) THIS_ID addSvgFromUrl:(NSURL *) APPKIT_ID(url)]);
	APPKIT_END
}

ZEND_METHOD(RAScene, updateDrawsInRangeUsingBlock)
{
	zend_object *range;
	zend_fcall_info fci;
	zend_fcall_info_cache fcc;
	NSRange r;

	ZEND_PARSE_PARAMETERS_START(2, 2)
		Z_PARAM_OBJ_OF_CLASS(range, appkit_ce_NSRange)
		Z_PARAM_FUNC(fci, fcc)
	ZEND_PARSE_PARAMETERS_END();
	if (!appkit_range_from(range, 1, &r)) {
		RETURN_THROWS();
	}

	/*
	 * The block is NS_NOESCAPE: Rasterizer calls it inline, on this thread, before this returns.
	 * Once PHP has an exception pending (thrown by the callable, or by a binding it called) no
	 * further PHP is entered: the remaining draws answer NO, unchanged. A bailout (exit(), a fatal
	 * error) is caught inside the block so it does not unwind through Rasterizer's frames, and is
	 * resumed once Rasterizer has returned and closed its update.
	 */
	__block bool bailed = false;

	APPKIT_BEGIN
		[(RAScene *) THIS_ID updateDrawsInRange:r usingBlock:^BOOL(NSInteger index, RADraw *draw) {
			if (bailed || EG(exception) != NULL) {
				return NO;
			}

			zval args[2], retval;
			bool changed = false;

			ZVAL_LONG(&args[0], (zend_long) index);
			appkit_box_objc(&args[1], draw);
			ZVAL_UNDEF(&retval);

			zend_fcall_info call = fci;
			zend_fcall_info_cache cache = fcc;

			zend_try {
				call.retval = &retval;
				call.params = args;
				call.param_count = 2;
				call.named_params = NULL;
				if (zend_call_function(&call, &cache) == SUCCESS && EG(exception) == NULL) {
					changed = zend_is_true(&retval);
				}
			} zend_catch {
				bailed = true;
			} zend_end_try();

			zval_ptr_dtor(&retval);
			zval_ptr_dtor(&args[1]);
			return changed ? YES : NO;
		}];
	APPKIT_END

	if (bailed) {
		zend_bailout();
	}
}

/* ---- RASceneList ----------------------------------------------------------------------- */

ZEND_METHOD(RASceneList, init)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RASceneList *made = [[CALLED alloc] init];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RASceneList, initWithScene)
{
	zend_object *scene;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(scene, mindbrix_ce_RAScene)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		RASceneList *made = [[CALLED alloc] initWithScene:(RAScene *) APPKIT_ID(scene)];
		appkit_box_objc(return_value, made);
		[made release];
	APPKIT_END
}

ZEND_METHOD(RASceneList, bounds)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_return_rect(return_value, [(RASceneList *) THIS_ID bounds]);
	APPKIT_END
}

ZEND_METHOD(RASceneList, ctm)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		mindbrix_return_transform(return_value, [(RASceneList *) THIS_ID ctm]);
	APPKIT_END
}

ZEND_METHOD(RASceneList, setCtm)
{
	zend_object *ctm;
	CGAffineTransform t;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(ctm, mindbrix_ce_CGAffineTransform)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_transform_from(ctm, 1, &t)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID setCtm:t];
	APPKIT_END
}

ZEND_METHOD(RASceneList, clearColor)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		appkit_box_objc(return_value, [(RASceneList *) THIS_ID clearColor]);
	APPKIT_END
}

ZEND_METHOD(RASceneList, setClearColor)
{
	zend_object *clearColor;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(clearColor, mindbrix_ce_RAPaint)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID setClearColor:(RAPaint *) APPKIT_ID(clearColor)];
	APPKIT_END
}

ZEND_METHOD(RASceneList, useClips)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_BOOL([(RASceneList *) THIS_ID useClips]);
	APPKIT_END
}

ZEND_METHOD(RASceneList, setUseClips)
{
	bool useClips;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_BOOL(useClips)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID setUseClips:useClips];
	APPKIT_END
}

ZEND_METHOD(RASceneList, useCurves)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_BOOL([(RASceneList *) THIS_ID useCurves]);
	APPKIT_END
}

ZEND_METHOD(RASceneList, setUseCurves)
{
	bool useCurves;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_BOOL(useCurves)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID setUseCurves:useCurves];
	APPKIT_END
}

ZEND_METHOD(RASceneList, showOpaques)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_BOOL([(RASceneList *) THIS_ID showOpaques]);
	APPKIT_END
}

ZEND_METHOD(RASceneList, setShowOpaques)
{
	bool showOpaques;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_BOOL(showOpaques)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID setShowOpaques:showOpaques];
	APPKIT_END
}

ZEND_METHOD(RASceneList, showOutlines)
{
	ZEND_PARSE_PARAMETERS_NONE();

	APPKIT_BEGIN
		RETVAL_BOOL([(RASceneList *) THIS_ID showOutlines]);
	APPKIT_END
}

ZEND_METHOD(RASceneList, setShowOutlines)
{
	bool showOutlines;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_BOOL(showOutlines)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID setShowOutlines:showOutlines];
	APPKIT_END
}

ZEND_METHOD(RASceneList, addList)
{
	zend_object *list;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(list, mindbrix_ce_RASceneList)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID addList:(RASceneList *) APPKIT_ID(list)];
	APPKIT_END
}

ZEND_METHOD(RASceneList, addScene)
{
	zend_object *scene;

	ZEND_PARSE_PARAMETERS_START(1, 1)
		Z_PARAM_OBJ_OF_CLASS(scene, mindbrix_ce_RAScene)
	ZEND_PARSE_PARAMETERS_END();

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID addScene:(RAScene *) APPKIT_ID(scene)];
	APPKIT_END
}

ZEND_METHOD(RASceneList, addSceneCtmClip)
{
	zend_object *scene, *ctm, *clip;
	CGAffineTransform t;
	NSRect r;

	ZEND_PARSE_PARAMETERS_START(3, 3)
		Z_PARAM_OBJ_OF_CLASS(scene, mindbrix_ce_RAScene)
		Z_PARAM_OBJ_OF_CLASS(ctm, mindbrix_ce_CGAffineTransform)
		Z_PARAM_OBJ_OF_CLASS(clip, appkit_ce_NSRect)
	ZEND_PARSE_PARAMETERS_END();
	if (!mindbrix_transform_from(ctm, 2, &t) || !appkit_rect_from(clip, 3, &r)) {
		RETURN_THROWS();
	}

	APPKIT_BEGIN
		[(RASceneList *) THIS_ID addScene:(RAScene *) APPKIT_ID(scene) ctm:t clip:r];
	APPKIT_END
}
