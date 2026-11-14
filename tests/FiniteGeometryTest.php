<?php

declare(strict_types=1);

/*
 * Rasterizer's curve writers count subdivisions in a float; non-finite geometry made that count
 * never reach 0 (the display hung, memory grew until the process was killed). lib/Rasterizer
 * carries the fix, and the binding refuses non-finite geometry. Both are held here.
 */

it('refuses non-finite path coordinates', function (float $bad) {
    $path = RAPath::init();

    expect(fn () => $path->moveToY($bad, 0))->toThrow(ValueError::class, 'must be finite')
        ->and(fn () => $path->lineToY(0, $bad))->toThrow(ValueError::class, 'must be finite')
        ->and(fn () => $path->quadToY1X2Y2(0, 0, $bad, 0))->toThrow(ValueError::class, 'must be finite')
        ->and(fn () => $path->cubicToY1X2Y2X3Y3(0, 0, 0, 0, 0, $bad))->toThrow(ValueError::class, 'must be finite');
})->with([INF, -INF, NAN]);

it('refuses non-finite shape rects and corner sizes', function () {
    $bad = new NSRect(0, 0, INF, 10);

    expect(fn () => RAPath::initWithRect($bad))->toThrow(ValueError::class, 'must have finite properties')
        ->and(fn () => RAPath::initWithEllipse($bad))->toThrow(ValueError::class, 'must have finite properties')
        ->and(fn () => RAPath::init()->addRect($bad))->toThrow(ValueError::class, 'must have finite properties')
        ->and(fn () => RAPath::init()->addEllipse($bad))->toThrow(ValueError::class, 'must have finite properties')
        ->and(fn () => RAPath::initWithRoundedRectCornerWidthCornerHeight(new NSRect(0, 0, 10, 10), NAN, 2))->toThrow(ValueError::class, 'must be finite')
        ->and(fn () => RAPath::init()->addRoundedRectCornerWidthCornerHeight(new NSRect(0, 0, 10, 10), 2, INF))->toThrow(ValueError::class, 'must be finite');
});

it('refuses non-finite transforms, stroke widths and dashes', function () {
    $path = RAPath::initWithRect(new NSRect(0, 0, 10, 10));
    $scene = RAScene::init();

    expect(fn () => RADraw::initWithPathCtmColor($path, new CGAffineTransform(NAN, 0, 0, 1, 0, 0), red()))->toThrow(ValueError::class, 'must have finite properties')
        ->and(fn () => $scene->addFillCtmColorEvenOddClipClipPathBlendMode($path, new CGAffineTransform(1, 0, 0, 1, INF, 0), red(), false, noClip(), null, RABlendMode::NORMAL))->toThrow(ValueError::class, 'must have finite properties')
        ->and(fn () => $scene->addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode($path, identity(), red(), INF, RACapStyle::BUTT, RAJoinStyle::MITER, noClip(), null, RABlendMode::NORMAL))->toThrow(ValueError::class, 'must be finite')
        ->and(fn () => RADraw::init()->setWidth(NAN))->toThrow(ValueError::class, 'must be finite')
        ->and(fn () => RASceneList::init()->setCtm(new CGAffineTransform(1, 0, 0, INF, 0, 0)))->toThrow(ValueError::class, 'must have finite properties')
        ->and(fn () => $path->dashedCopyWithPhaseLengths(NAN, [1, 1]))->toThrow(ValueError::class, 'must be finite')
        ->and(fn () => $path->dashedCopyWithPhaseLengths(0, [1, INF]))->toThrow(ValueError::class, 'must contain only finite values')
        ->and($scene->count())->toBe(0);
});

it('still takes CGRectNull as a clip', function () {
    $scene = RAScene::init();
    $scene->addFillCtmColorEvenOddClipClipPathBlendMode(RAPath::initWithRect(new NSRect(0, 0, 10, 10)), identity(), red(), false, noClip(), null, RABlendMode::NORMAL);

    expect($scene->count())->toBe(1);
});

it('draws curves under a transform whose squares overflow float, on both paths', function (bool $useCG) {
    // Finite numbers the binding takes: at a 1e20 scale, squares of device coordinates pass FLT_MAX.
    // Before lib/Rasterizer's fix the Metal path looped forever here; run in a child with a deadline.
    $script = sprintf(<<<'PHP'
        $p = RAPath::init(); $p->moveToY(0, 0); $p->quadToY1X2Y2(10, 30, 20, 0); $p->cubicToY1X2Y2X3Y3(30, 30, 40, -10, 50, 10); $p->close();
        $s = RAScene::init();
        $s->addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode($p, new CGAffineTransform(1e20, 0, 0, 1e20, 0, 0), RAPaint::initWithGrayAlpha(0, 1), 1, RACapStyle::ROUND, RAJoinStyle::MITER, new NSRect(INF, INF, 0, 0), null, RABlendMode::NORMAL);
        $d = new ObjCDelegate('RASceneListDelegate'); $d->on('getListAtTime:scale:width:height:', fn () => RASceneList::initWithScene($s));
        $v = RasterizerView::initWithFrame(new NSRect(0, 0, 32, 32)); $v->setUseCG(%s); $v->setListDelegate($d);
        $v->setNeedsDisplay(true); $v->displayIfNeeded(); usleep(50000); echo "drawn";
        PHP, $useCG ? 'true' : 'false');

    $proc = proc_open([PHP_BINARY, '-r', $script], [1 => ['pipe', 'w'], 2 => ['file', '/dev/null', 'w']], $pipes);
    $start = microtime(true);
    while (($status = proc_get_status($proc))['running'] && microtime(true) - $start < 10) {
        usleep(10000);
    }
    if ($status['running']) {
        proc_terminate($proc, 9);
    }
    $out = stream_get_contents($pipes[1]);
    proc_close($proc);

    expect($status['running'])->toBeFalse()->and($out)->toBe('drawn');
})->with(['Metal' => false, 'Core Graphics' => true]);
