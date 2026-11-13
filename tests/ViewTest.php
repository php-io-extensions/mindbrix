<?php

declare(strict_types=1);

/*
 * RasterizerView driven off-screen: it is never in a window, so nothing appears on screen.
 * displayIfNeeded() makes its layer display once, which asks the PHP delegate for a list.
 * Pixels are checked by tests/NativeRenderTest.php: appkit binds no CGImage readback.
 */

/** @return array{RasterizerView, ObjCDelegate, ArrayObject} */
function squareView(bool $useCG): array
{
    $calls = new ArrayObject();
    $delegate = new ObjCDelegate('RASceneListDelegate');
    $delegate->on('shouldRedrawAtTime:scale:width:height:', fn () => true);
    $delegate->on('getListAtTime:scale:width:height:', function (float $time, float $scale, float $width, float $height) use ($calls) {
        $calls[] = [$scale, $width, $height];
        $list = RASceneList::initWithScene(sceneWithFill(RAPath::initWithRect(new NSRect(16, 16, 32, 32))));
        $list->setClearColor(RAPaint::initWithGrayAlpha(1, 1));

        return $list;
    });

    $view = RasterizerView::initWithFrame(new NSRect(0, 0, 64, 48));
    $view->setUseCG($useCG);
    $view->setListDelegate($delegate);

    return [$view, $delegate, $calls];
}

it('is an NSView made by initWithFrame, drawing with Metal by default', function () {
    $view = RasterizerView::initWithFrame(new NSRect(0, 0, 10, 10));

    expect($view)->toBeInstanceOf(NSView::class)
        ->and($view->useCG())->toBeFalse()
        ->and($view->layer()->className())->toBe('RasterizerLayer')
        ->and($view->listDelegate())->toBeNull();
});

it('holds its delegate weakly and answers the same object', function () {
    [$view, $delegate] = squareView(false);

    expect($view->listDelegate())->toBe($delegate);
    $view->setListDelegate(null);
    expect($view->listDelegate())->toBeNull();
});

it('asks the delegate for its list when the Metal layer displays', function () {
    [$view, $delegate, $calls] = squareView(false);

    $view->setNeedsDisplay(true);
    $view->displayIfNeeded();

    expect($calls)->toHaveCount(1)
        ->and($calls[0][1])->toBe(64.0)
        ->and($calls[0][2])->toBe(48.0);
});

it('draws the delegate list into a CGImage with Core Graphics', function () {
    [$view, $delegate, $calls] = squareView(true);

    expect($view->useCG())->toBeTrue()
        ->and($view->layer()->className())->toBe('CALayer');
    $view->setNeedsDisplay(true);
    $view->displayIfNeeded();

    $contents = $view->layer()->contents();
    $scale = $calls[0][0];
    expect($calls)->toHaveCount(1)
        ->and($contents)->toBeInstanceOf(CGImage::class)
        ->and($contents->getWidth())->toBe((int) ceil(64 * $scale))
        ->and($contents->getHeight())->toBe((int) ceil(48 * $scale));
});
