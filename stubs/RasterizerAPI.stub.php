<?php

/** @generate-class-entries */

/** RACapStyle: kCapButt, kCapSquare, kCapRound. */
enum RACapStyle: int
{
    case BUTT = 0;
    case SQUARE = 1;
    case ROUND = 2;
}

/** RAJoinStyle: kJoinMiter, kJoinRound. */
enum RAJoinStyle: int
{
    case MITER = 0;
    case ROUND = 1;
}

/** RABlendMode: CGBlendMode's separable and non-separable modes, kRABlendNormal … kRABlendLuminosity. */
enum RABlendMode: int
{
    case NORMAL = 0;
    case MULTIPLY = 1;
    case SCREEN = 2;
    case OVERLAY = 3;
    case DARKEN = 4;
    case LIGHTEN = 5;
    case COLOR_DODGE = 6;
    case COLOR_BURN = 7;
    case SOFT_LIGHT = 8;
    case HARD_LIGHT = 9;
    case DIFFERENCE = 10;
    case EXCLUSION = 11;
    case HUE = 12;
    case SATURATION = 13;
    case COLOR = 14;
    case LUMINOSITY = 15;
}

/**
 * CGAffineTransform, the struct: [a b 0; c d 0; tx ty 1]. appkit has no class for it.
 *
 * @not-serializable
 */
final class CGAffineTransform
{
    public float $a;

    public float $b;

    public float $c;

    public float $d;

    public float $tx;

    public float $ty;

    public function __construct(float $a, float $b, float $c, float $d, float $tx, float $ty) {}
}

/**
 * @not-serializable
 */
class RAPaint extends NSObject
{
    public static function init(): static {}

    public static function initWithGrayAlpha(float $gray, float $alpha): static {}

    public static function initWithHueSaturationValueAlpha(float $hue, float $saturation, float $value, float $alpha): static {}

    public static function initWithRedGreenBlueAlpha(float $red, float $green, float $blue, float $alpha): static {}

    public static function initWithCGColor(CGColor $cgColor): static {}

    /**
     * @param array $colors RAPaint objects
     * @param array $locations ints or floats, one per colour
     */
    public static function initLinearLocationsStartEnd(array $colors, array $locations, NSPoint $start, NSPoint $end): static {}

    /**
     * @param array $colors RAPaint objects
     * @param array $locations ints or floats, one per colour
     */
    public static function initRadialLocationsCenterRadius(array $colors, array $locations, NSPoint $center, float $radius): static {}

    public static function initWithCGImage(CGImage $cgImage): static {}
}

/**
 * @not-serializable
 */
class RAPath extends NSObject
{
    public static function init(): static {}

    public function bounds(): NSRect {}

    /** $cgPath is a CGPathRef (CFType::fromPointer() of one); any other CF type is a TypeError. */
    public static function initWithCGPath(CFType $cgPath): static {}

    public static function initWithRect(NSRect $rect): static {}

    public static function initWithEllipse(NSRect $rect): static {}

    public static function initWithRoundedRectCornerWidthCornerHeight(NSRect $rect, float $cornerWidth, float $cornerHeight): static {}

    public function moveToY(float $x, float $y): void {}

    public function lineToY(float $x, float $y): void {}

    public function quadToY1X2Y2(float $x1, float $y1, float $x2, float $y2): void {}

    public function cubicToY1X2Y2X3Y3(float $x1, float $y1, float $x2, float $y2, float $x3, float $y3): void {}

    public function close(): void {}

    /** $path is a CGPathRef (CFType::fromPointer() of one); any other CF type is a TypeError. */
    public function addCGPath(CFType $path): void {}

    public function addRect(NSRect $rect): void {}

    public function addEllipse(NSRect $rect): void {}

    public function addRoundedRectCornerWidthCornerHeight(NSRect $rect, float $cornerWidth, float $cornerHeight): void {}

    /** @param array $lengths ints or floats */
    public function dashedCopyWithPhaseLengths(float $phase, array $lengths): RAPath {}
}

/**
 * A draw: make one to add with RAScene::addDraw(), or edit a scene's draws in place with
 * RAScene::updateDrawsInRangeUsingBlock().
 *
 * @not-serializable
 */
class RADraw extends NSObject
{
    public static function init(): static {}

    public static function initWithPathCtmColor(RAPath $path, CGAffineTransform $ctm, RAPaint $color): static {}

    public function path(): RAPath {}

    public function setPath(RAPath $path): void {}

    public function ctm(): CGAffineTransform {}

    public function setCtm(CGAffineTransform $ctm): void {}

    public function color(): RAPaint {}

    public function setColor(RAPaint $color): void {}

    /** 0 fills, > 0 strokes. */
    public function width(): float {}

    public function setWidth(float $width): void {}

    public function evenOdd(): bool {}

    public function setEvenOdd(bool $evenOdd): void {}

    public function capStyle(): RACapStyle {}

    public function setCapStyle(RACapStyle $capStyle): void {}

    public function joinStyle(): RAJoinStyle {}

    public function setJoinStyle(RAJoinStyle $joinStyle): void {}

    /** Empty, null or infinite clips nothing. */
    public function clip(): NSRect {}

    public function setClip(NSRect $clip): void {}

    public function clipPath(): ?RAPath {}

    public function setClipPath(?RAPath $clipPath): void {}

    /** The clip path's fill rule, else non-zero. */
    public function clipEvenOdd(): bool {}

    public function setClipEvenOdd(bool $clipEvenOdd): void {}

    /** Hidden draws keep their index, but are not drawn. */
    public function hidden(): bool {}

    public function setHidden(bool $hidden): void {}

    public function blendMode(): RABlendMode {}

    public function setBlendMode(RABlendMode $blendMode): void {}
}

/**
 * @not-serializable
 */
class RAScene extends NSObject
{
    public static function init(): static {}

    public function bounds(): NSRect {}

    public function count(): int {}

    public function addDraw(RADraw $draw): void {}

    public function addImageCtm(RAPaint $image, CGAffineTransform $ctm): void {}

    public function addFillCtmColorEvenOddClipClipPathBlendMode(RAPath $path, CGAffineTransform $ctm, RAPaint $color, bool $evenOdd, NSRect $clip, ?RAPath $clipPath, RABlendMode $blendMode): void {}

    public function addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode(RAPath $path, CGAffineTransform $ctm, RAPaint $color, float $width, RACapStyle $capStyle, RAJoinStyle $joinStyle, NSRect $clip, ?RAPath $clipPath, RABlendMode $blendMode): void {}

    public function addTextInRectCtmClip(NSAttributedString $string, NSRect $rect, CGAffineTransform $ctm, NSRect $clip): NSRect {}

    public static function pdfPageCountFromUrl(NSURL $url): int {}

    public function addPdfFromUrlPageIndex(NSURL $url, int $pageIndex): CGAffineTransform {}

    public function addSvgFromUrl(NSURL $url): CGAffineTransform {}

    /**
     * Calls $block(int $index, RADraw $draw): bool for each draw in range, clamped to count, to read or
     * edit it; it returns true if it changed the draw. The RADraw is the scene's draw only during that call.
     * Adding to the scene from the block raises AppKitException (NSInternalInconsistencyException).
     */
    public function updateDrawsInRangeUsingBlock(NSRange $range, callable $block): void {}
}

/**
 * @not-serializable
 */
class RASceneList extends NSObject
{
    public static function init(): static {}

    public static function initWithScene(RAScene $scene): static {}

    public function bounds(): NSRect {}

    public function ctm(): CGAffineTransform {}

    public function setCtm(CGAffineTransform $ctm): void {}

    public function clearColor(): RAPaint {}

    public function setClearColor(RAPaint $clearColor): void {}

    public function useClips(): bool {}

    public function setUseClips(bool $useClips): void {}

    public function useCurves(): bool {}

    public function setUseCurves(bool $useCurves): void {}

    public function showOpaques(): bool {}

    public function setShowOpaques(bool $showOpaques): void {}

    public function showOutlines(): bool {}

    public function setShowOutlines(bool $showOutlines): void {}

    public function addList(RASceneList $list): void {}

    public function addScene(RAScene $scene): void {}

    public function addSceneCtmClip(RAScene $scene, CGAffineTransform $ctm, NSRect $clip): void {}
}
