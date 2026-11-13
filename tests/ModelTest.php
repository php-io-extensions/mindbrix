<?php

declare(strict_types=1);

describe('CGAffineTransform', function () {
    it('holds the six fields', function () {
        $t = new CGAffineTransform(1, 2, 3, 4, 5, 6);

        expect([$t->a, $t->b, $t->c, $t->d, $t->tx, $t->ty])->toBe([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
    });

    it('refuses one with an unset field', function () {
        $t = (new ReflectionClass(CGAffineTransform::class))->newInstanceWithoutConstructor();

        expect(fn () => RADraw::initWithPathCtmColor(RAPath::init(), $t, red()))
            ->toThrow(ValueError::class, 'must have every property initialized');
    });
});

describe('RAPaint', function () {
    it('makes every kind of paint', function () {
        $stops = [red(), RAPaint::initWithGrayAlpha(0, 1)];

        expect(RAPaint::init())->toBeInstanceOf(RAPaint::class)
            ->and(RAPaint::initWithGrayAlpha(0.5, 1))->toBeInstanceOf(RAPaint::class)
            ->and(RAPaint::initWithHueSaturationValueAlpha(0.3, 1, 1, 1))->toBeInstanceOf(RAPaint::class)
            ->and(RAPaint::initWithCGColor(NSColor::colorWithRedGreenBlueAlpha(0, 1, 0, 1)->CGColor()))->toBeInstanceOf(RAPaint::class)
            ->and(RAPaint::initLinearLocationsStartEnd($stops, [0, 1.0], new NSPoint(0, 0), new NSPoint(10, 0)))->toBeInstanceOf(RAPaint::class)
            ->and(RAPaint::initRadialLocationsCenterRadius($stops, [0, 1], new NSPoint(5, 5), 5))->toBeInstanceOf(RAPaint::class);
    });

    it('type-checks the gradient arrays', function () {
        expect(fn () => RAPaint::initLinearLocationsStartEnd([red(), 'blue'], [0, 1], new NSPoint(0, 0), new NSPoint(1, 0)))
            ->toThrow(TypeError::class, 'must contain only RAPaint objects')
            ->and(fn () => RAPaint::initRadialLocationsCenterRadius([red(), red()], [0, '1'], new NSPoint(0, 0), 1))
            ->toThrow(TypeError::class, 'must contain only int or float values');
    });

    it('takes a CGImage, which addImageCtm draws at the image size', function () {
        $w = 3;
        $h = 2;
        $bytes = str_repeat("\xff\x00\x00\xff", $w * $h);
        $image = CGImage::create($w, $h, 8, 32, $w * 4, CGColorSpace::createWithName(kCGColorSpaceSRGB),
            kCGImageAlphaPremultipliedLast, CGDataProvider::createWithCFData(CFData::create(null, $bytes, strlen($bytes))), null, false, 0);

        $scene = RAScene::init();
        $scene->addImageCtm(RAPaint::initWithCGImage($image), new CGAffineTransform(1, 0, 0, 1, 10, 20));

        expect($scene->count())->toBe(1)
            ->and(rectArray($scene->bounds()))->toBe([10.0, 20.0, 3.0, 2.0]);
    });

    it('ignores a non-image paint in addImageCtm, as Rasterizer does', function () {
        $scene = RAScene::init();
        $scene->addImageCtm(red(), identity());

        expect($scene->count())->toBe(0);
    });
});

describe('RAPath', function () {
    it('reports its bounds once a scene has validated it', function () {
        $path = RAPath::initWithRect(new NSRect(10, 20, 30, 40));
        sceneWithFill($path);

        expect(rectArray($path->bounds()))->toBe([10.0, 20.0, 30.0, 40.0]);
    });

    it('builds from segments', function () {
        $path = RAPath::init();
        $path->moveToY(0, 0);
        $path->lineToY(10, 0);
        $path->quadToY1X2Y2(20, 0, 20, 10);
        $path->cubicToY1X2Y2X3Y3(20, 20, 0, 20, 0, 10);
        $path->close();
        $path->addEllipse(new NSRect(40, 0, 10, 10));
        $path->addRoundedRectCornerWidthCornerHeight(new NSRect(0, 30, 10, 10), 2, 2);
        $path->addRect(new NSRect(60, 60, 5, 5));
        sceneWithFill($path);

        expect(rectArray($path->bounds()))->toBe([0.0, 0.0, 65.0, 65.0]);
    });

    it('makes ellipse and rounded rect paths', function () {
        $ellipse = RAPath::initWithEllipse(new NSRect(0, 0, 20, 10));
        $rounded = RAPath::initWithRoundedRectCornerWidthCornerHeight(new NSRect(5, 5, 10, 10), 3, 3);
        sceneWithFill($ellipse);
        sceneWithFill($rounded);

        expect(rectArray($ellipse->bounds()))->toBe([0.0, 0.0, 20.0, 10.0])
            ->and(rectArray($rounded->bounds()))->toBe([5.0, 5.0, 10.0, 10.0]);
    });

    it('makes a dashed copy, or answers itself for fewer than two lengths', function () {
        $line = RAPath::init();
        $line->moveToY(0, 0);
        $line->lineToY(100, 0);

        $dashed = $line->dashedCopyWithPhaseLengths(0, [10, 10]);

        expect($dashed)->not->toBe($line)
            ->and($line->dashedCopyWithPhaseLengths(0, [10]))->toBe($line);
    });

    it('takes only a CFType wrapping a CGPathRef', function () {
        expect(fn () => RAPath::initWithCGPath(CFAllocator::getDefault()))->toThrow(TypeError::class, 'must wrap a CGPathRef')
            ->and(fn () => RAPath::init()->addCGPath(CFAllocator::getDefault()))->toThrow(TypeError::class, 'must wrap a CGPathRef');
    });
});

describe('RADraw', function () {
    it('starts as Rasterizer makes it', function () {
        $draw = RADraw::init();

        expect($draw->width())->toBe(0.0)
            ->and($draw->evenOdd())->toBeFalse()
            ->and($draw->capStyle())->toBe(RACapStyle::BUTT)
            ->and($draw->joinStyle())->toBe(RAJoinStyle::MITER)
            ->and($draw->blendMode())->toBe(RABlendMode::NORMAL)
            ->and($draw->clipPath())->toBeNull()
            ->and($draw->hidden())->toBeFalse();
    });

    it('round-trips every property', function () {
        $path = RAPath::initWithRect(new NSRect(0, 0, 10, 10));
        $draw = RADraw::initWithPathCtmColor($path, new CGAffineTransform(2, 0, 0, 2, 3, 4), red());
        $clipPath = RAPath::initWithEllipse(new NSRect(0, 0, 5, 5));

        $draw->setWidth(3);
        $draw->setEvenOdd(true);
        $draw->setCapStyle(RACapStyle::ROUND);
        $draw->setJoinStyle(RAJoinStyle::ROUND);
        $draw->setClip(new NSRect(1, 2, 30, 40));
        $draw->setClipPath($clipPath);
        $draw->setClipEvenOdd(true);
        $draw->setHidden(true);
        $draw->setBlendMode(RABlendMode::LUMINOSITY);
        $draw->setCtm(new CGAffineTransform(1, 0, 0, 1, 7, 8));

        $ctm = $draw->ctm();
        expect($draw->width())->toBe(3.0)
            ->and($draw->evenOdd())->toBeTrue()
            ->and($draw->capStyle())->toBe(RACapStyle::ROUND)
            ->and($draw->joinStyle())->toBe(RAJoinStyle::ROUND)
            ->and(rectArray($draw->clip()))->toBe([1.0, 2.0, 30.0, 40.0])
            ->and($draw->clipPath())->toBeInstanceOf(RAPath::class)
            ->and($draw->clipEvenOdd())->toBeTrue()
            ->and($draw->hidden())->toBeTrue()
            ->and($draw->blendMode())->toBe(RABlendMode::LUMINOSITY)
            ->and([$ctm->a, $ctm->tx, $ctm->ty])->toBe([1.0, 7.0, 8.0])
            ->and($draw->path())->toBeInstanceOf(RAPath::class)
            ->and($draw->color())->toBeInstanceOf(RAPaint::class);

        $draw->setClipPath(null);
        expect($draw->clipPath())->toBeNull();
    });

    it('reads a null clip back as CGRectInfinite', function () {
        $draw = RADraw::init();
        $draw->setClip(noClip());

        expect($draw->clip()->width)->toBe(PHP_FLOAT_MAX);
    });

    it('round-trips every cap style and blend mode', function () {
        $draw = RADraw::init();
        foreach (RACapStyle::cases() as $cap) {
            $draw->setCapStyle($cap);
            expect($draw->capStyle())->toBe($cap);
        }
        foreach (RABlendMode::cases() as $mode) {
            $draw->setBlendMode($mode);
            expect($draw->blendMode())->toBe($mode);
        }
    });
});

describe('RAScene', function () {
    it('counts and bounds its fills and strokes', function () {
        $scene = sceneWithFill(RAPath::initWithRect(new NSRect(0, 0, 10, 10)));
        $line = RAPath::init();
        $line->moveToY(20, 20);
        $line->lineToY(40, 20);
        $scene->addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode($line, identity(), red(), 2, RACapStyle::BUTT, RAJoinStyle::MITER, noClip(), null, RABlendMode::NORMAL);
        $scene->addDraw(RADraw::initWithPathCtmColor(RAPath::initWithRect(new NSRect(50, 50, 5, 5)), identity(), red()));

        expect($scene->count())->toBe(3)
            ->and(rectArray($scene->bounds()))->toBe([0.0, 0.0, 55.0, 55.0]);
    });

    it('lays out text', function () {
        $string = NSAttributedString::initWithStringAttributes('Hello', [NSFontAttributeName => NSFont::systemFontOfSizeWeight(20, 0)]);
        $scene = RAScene::init();

        $used = $scene->addTextInRectCtmClip($string, new NSRect(0, 0, 200, 50), identity(), noClip());

        expect($scene->count())->toBeGreaterThan(0)
            ->and($used->width)->toBeGreaterThan(0.0)
            ->and($used->height)->toBeGreaterThan(0.0);
    });

    it('imports an SVG', function () {
        $svg = tempFile('.svg', '<svg xmlns="http://www.w3.org/2000/svg" width="40" height="30"><rect x="5" y="5" width="20" height="10" fill="red"/></svg>');
        $scene = RAScene::init();

        $scene->addSvgFromUrl(NSURL::fileURLWithPath($svg));

        expect($scene->count())->toBe(1);
    });

    it('counts and imports PDF pages', function () {
        $pdf = NSURL::fileURLWithPath(pdfFile(2));
        $scene = RAScene::init();

        expect(RAScene::pdfPageCountFromUrl($pdf))->toBe(2);
        $scene->addPdfFromUrlPageIndex($pdf, 1);
        expect($scene->count())->toBeGreaterThan(0);
    });

    it('updates draws in a clamped range through the block', function () {
        $scene = sceneWithFill(RAPath::initWithRect(new NSRect(0, 0, 10, 10)));
        $scene->addDraw(RADraw::initWithPathCtmColor(RAPath::initWithRect(new NSRect(0, 0, 5, 5)), identity(), red()));
        $seen = [];

        $scene->updateDrawsInRangeUsingBlock(new NSRange(0, 100), function (int $index, RADraw $draw) use (&$seen) {
            $seen[] = $index;
            $draw->setHidden($index === 1);

            return $index === 1;
        });

        $hidden = [];
        $scene->updateDrawsInRangeUsingBlock(new NSRange(0, 2), function (int $index, RADraw $draw) use (&$hidden) {
            $hidden[$index] = $draw->hidden();

            return false;
        });
        expect($seen)->toBe([0, 1])->and($hidden)->toBe([false, true]);
    });

    it('detaches a draw kept past the block from the scene', function () {
        $scene = sceneWithFill(RAPath::initWithRect(new NSRect(0, 0, 10, 10)));
        $kept = null;
        $scene->updateDrawsInRangeUsingBlock(new NSRange(0, 1), function (int $index, RADraw $draw) use (&$kept) {
            $kept = $draw;

            return false;
        });

        $kept->setWidth(9);
        $width = null;
        $scene->updateDrawsInRangeUsingBlock(new NSRange(0, 1), function (int $index, RADraw $draw) use (&$width) {
            $width = $draw->width();

            return false;
        });

        expect($kept->width())->toBe(9.0)->and($width)->toBe(0.0);
    });

    it('raises AppKitException when the block adds to the scene', function () {
        $scene = sceneWithFill(RAPath::initWithRect(new NSRect(0, 0, 10, 10)));

        expect(fn () => $scene->updateDrawsInRangeUsingBlock(new NSRange(0, 1), fn (int $i, RADraw $d) => $scene->addDraw(RADraw::init())))
            ->toThrow(AppKitException::class, 'NSInternalInconsistencyException');
        $scene->addDraw(RADraw::init());
        expect($scene->count())->toBe(2);
    });

    it('stops calling the block once it throws', function () {
        $scene = sceneWithFill(RAPath::initWithRect(new NSRect(0, 0, 10, 10)));
        $scene->addDraw(RADraw::init());
        $calls = 0;

        expect(function () use ($scene, &$calls) {
            $scene->updateDrawsInRangeUsingBlock(new NSRange(0, 2), function () use (&$calls) {
                $calls++;
                throw new RuntimeException('stop');
            });
        })->toThrow(RuntimeException::class, 'stop');
        expect($calls)->toBe(1);
    });
});

describe('RASceneList', function () {
    it('round-trips its properties and holds scenes', function () {
        $scene = sceneWithFill(RAPath::initWithRect(new NSRect(0, 0, 10, 10)));
        $list = RASceneList::initWithScene($scene);
        $list->setCtm(new CGAffineTransform(1, 0, 0, 1, 3, 4));
        $list->setClearColor(RAPaint::initWithGrayAlpha(1, 1));
        $list->setUseClips(false);
        $list->setUseCurves(true);
        $list->setShowOpaques(true);
        $list->setShowOutlines(true);

        $inner = RASceneList::init();
        $inner->addScene($scene);
        $inner->addSceneCtmClip($scene, new CGAffineTransform(1, 0, 0, 1, 100, 0), noClip());
        $list->addList($inner);

        expect($list->ctm()->tx)->toBe(3.0)
            ->and($list->clearColor())->toBeInstanceOf(RAPaint::class)
            ->and($list->useClips())->toBeFalse()
            ->and($list->useCurves())->toBeTrue()
            ->and($list->showOpaques())->toBeTrue()
            ->and($list->showOutlines())->toBeTrue()
            ->and(rectArray($inner->bounds()))->toBe([0.0, 0.0, 110.0, 10.0]);
    });
});
