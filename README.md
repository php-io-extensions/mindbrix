# ext-mindbrix

1:1 PHP bindings of [mindbrix/Rasterizer](https://github.com/mindbrix/Rasterizer), a GPU vector renderer for macOS built on Metal. Paths, paints, gradients, images, text, SVG and PDF go into scenes; a `RasterizerView` draws a list of scenes each display frame.

The extension is named `mindbrix` so it is not confused with other rasterizers. Rasterizer is compiled in from `lib/Rasterizer` (unchanged, commit `2be4bc16`, its 0.1.0); nothing needs installing besides ext-appkit, which mindbrix's classes build on.

## Basic usage

```php
<?php

$scene = RAScene::init();
$scene->addFillCtmColorEvenOddClipClipPathBlendMode(
    RAPath::initWithRoundedRectCornerWidthCornerHeight(new NSRect(20, 20, 160, 80), 12, 12),
    new CGAffineTransform(1, 0, 0, 1, 0, 0),
    RAPaint::initLinearLocationsStartEnd(
        [RAPaint::initWithRedGreenBlueAlpha(1, 0.4, 0, 1), RAPaint::initWithRedGreenBlueAlpha(0.6, 0, 1, 1)],
        [0, 1],
        new NSPoint(20, 0),
        new NSPoint(180, 0),
    ),
    false,
    new NSRect(INF, INF, 0, 0),      // CGRectNull: no clip
    null,
    RABlendMode::NORMAL,
);

// The view asks its delegate for a list each frame. It holds the delegate weakly: keep $delegate.
$delegate = new ObjCDelegate('RASceneListDelegate');
$delegate->on('shouldRedrawAtTime:scale:width:height:', fn () => false);
$delegate->on('getListAtTime:scale:width:height:', function (float $time, float $scale, float $width, float $height) use ($scene) {
    $list = RASceneList::initWithScene($scene);
    $list->setClearColor(RAPaint::initWithGrayAlpha(1, 1));

    return $list;
});

$view = RasterizerView::initWithFrame(new NSRect(0, 0, 200, 120));
$view->setListDelegate($delegate);
// Put $view in a window's content view like any NSView; it draws while it is in a window.
echo $view->layer()->className(), "\n";   // RasterizerLayer
```

## Requirements

- macOS 14 or later with a Metal GPU. Rasterizer renders only through Metal; there is no Linux build.
- PHP 8.4 or later, NTS or ZTS.
- [ext-appkit](https://github.com/php-io-extensions/appkit) 0.11.2 or later, installed first: mindbrix compiles against its headers and its classes extend appkit's.
- Xcode Command Line Tools (clang, the macOS SDK). Homebrew's PHP ships `phpize` and `php-config`. No offline Metal compiler is needed: the shaders are compiled at run time by macOS.

## Installation

### With PHP PIE (recommended)

```bash
pie install php-io-extensions/mindbrix
```

### Manually (install script)

```bash
./install-macos.sh                      # Homebrew php@8.4 (NTS) and php@8.4-zts
./install-macos.sh /path/to/bin/php     # a specific PHP
```

It builds in a temporary copy, installs `mindbrix.so` into each PHP's `extension_dir`, signs it ad hoc and enables it with `30-mindbrix.ini`, which loads after `30-appkit.ini`.

### Manually (phpize)

```bash
phpize
./configure --enable-mindbrix
make
sudo make install
echo 'extension=mindbrix' > "$(php -r 'echo PHP_CONFIG_FILE_SCAN_DIR;')/30-mindbrix.ini"
```

### Verify

```bash
php --ri mindbrix
```

```
mindbrix support => enabled
Version => 0.11.0
mindbrix/Rasterizer => 2be4bc16
```

## API

Every class, selector and enum in Rasterizer's public headers (`RasterizerAPI.h`, `RasterizerView.h`): `RAPaint`, `RAPath`, `RADraw`, `RAScene`, `RASceneList`, `RasterizerView`, `RACapStyle`, `RAJoinStyle`, `RABlendMode`. The C++ core is not public API and is not bound. See [`stubs/`](stubs) for every signature.

### Translations

- **Names.** One method per selector, its keywords joined in camelCase: `addStroke:ctm:color:width:capStyle:joinStyle:clip:clipPath:blendMode:` is `addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode()`, `moveTo:y:` is `moveToY()`. `init…` selectors are static and return the class they are called on; `init()` is the plain `-init` each class is made with. Properties are a getter named as the property and a `set…` setter.
- **Objects.** Every class is an ext-appkit object (`RAScene extends NSObject`, `RasterizerView extends NSView`): one PHP object per native object, retained while PHP holds it, with appkit's `pointer()` and `fromPointer()`.
- **Values.** `CGRect` is appkit's `NSRect`, `CGPoint` is `NSPoint`, plus appkit's `NSRange`, `NSURL`, `NSAttributedString`, `CGColor` and `CGImage`. `CGAffineTransform` is mindbrix's own value class (`$a $b $c $d $tx $ty`). A `CGPathRef` is taken as appkit's `CFType` (from `CFType::fromPointer()`) and must be a CGPath. `NSArray<RAPaint *>` is a PHP list of `RAPaint`; `NSArray<NSNumber *>` a list of ints and floats.
- **Enums** are int-backed PHP enums named after the Objective-C enum, cases upper case without the prefix: `kCapRound` is `RACapStyle::ROUND`, `kRABlendColorDodge` is `RABlendMode::COLOR_DODGE`.
- **Clips.** `CGRectNull`, an empty rect or `CGRectInfinite` clips nothing; `new NSRect(INF, INF, 0, 0)` is `CGRectNull`.
- **Bounds.** Rasterizer computes a path's bounds when a scene validates it, so `RAPath::bounds()` is an empty box until the path has been added to a scene.

### Callbacks

- **The list delegate.** `RasterizerView` asks an `RASceneListDelegate` for its list. Implement it with appkit's `new ObjCDelegate('RASceneListDelegate')` and `on()` for `shouldRedrawAtTime:scale:width:height:` (return true to redraw on the next display frame) and `getListAtTime:scale:width:height:` (return an `RASceneList`). The view calls it on the main thread, from its display link while it is in a window, or from `displayIfNeeded()`. It holds the delegate weakly.
- **The update block.** `RAScene::updateDrawsInRangeUsingBlock()` calls `fn (int $index, RADraw $draw): bool` for each draw in the range, inline. The draw is the scene's own only during that call; return true when you changed it. Adding to the scene from inside raises `AppKitException`. Once the callable throws, the remaining draws are left alone and the exception continues after the call.

### Errors

An Objective-C exception Rasterizer raises becomes `AppKitException`. Arguments of the wrong type or with unset properties raise `TypeError` or `ValueError` before Rasterizer is called. `RasterizerView`'s methods are gated to the main thread, as appkit's views are.

## Running the test suite

```bash
composer install
php -d memory_limit=128M vendor/bin/pest
```

Nothing appears on screen: views are drawn off-screen. `tests/NativeRenderTest.php` compiles a small program from the extension's own sources to read back the pixels of both render paths (Metal and Core Graphics), which PHP has no API for; it needs clang. `php tools/sweep.php` is the crash sweep: every method with edge-case arguments, each in its own process, followed by a render of what it touched.

## Security

See [SECURITY.md](SECURITY.md).

## License

MIT, see [LICENSE](LICENSE). Rasterizer is MIT, see [`lib/Rasterizer/LICENSE.txt`](lib/Rasterizer/LICENSE.txt).
