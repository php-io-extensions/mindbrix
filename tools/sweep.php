<?php

/*
 * Crash sweep: calls every method of every mindbrix class with argument sets built from
 * its signature, each call in its own child process, then renders the scene the call
 * touched through RasterizerView's Metal and Core Graphics paths, off-screen (the views
 * are never in a window). A PHP exception is a pass; a signal (segfault, abort, an
 * uncaught Objective-C or C++ exception) or a hang is a failure.
 *
 *   php tools/sweep.php          # everything, prints the failures
 *   php tools/sweep.php --one RAPath::dashedCopyWithPhaseLengths:3
 */

const CLASSES = ['CGAffineTransform', 'RAPaint', 'RAPath', 'RADraw', 'RAScene', 'RASceneList', 'RasterizerView'];
const VARIANTS = 5;

function floatArg(int $v): float
{
    return [0.0, -1.0, 1e30, INF, NAN][$v];
}

function intArg(int $v): int
{
    return [0, -1, PHP_INT_MAX, PHP_INT_MIN, 3][$v];
}

function numberList(int $v): array
{
    return [[], [0, 0], [1e-30, 1e-30], [-1, 2], [NAN, INF, 1, 1]][$v];
}

function rect(int $v): NSRect
{
    return [new NSRect(0, 0, 0, 0), new NSRect(-10, -10, -5, -5), new NSRect(0, 0, 1e30, 1e30), new NSRect(INF, INF, 0, 0), new NSRect(NAN, NAN, NAN, NAN)][$v];
}

function transform(int $v): CGAffineTransform
{
    return [new CGAffineTransform(0, 0, 0, 0, 0, 0), new CGAffineTransform(-1, 0, 0, -1, -5, -5), new CGAffineTransform(1e30, 0, 0, 1e30, 0, 0),
        new CGAffineTransform(INF, 0, 0, INF, INF, INF), new CGAffineTransform(NAN, NAN, NAN, NAN, NAN, NAN)][$v];
}

function busyPath(): RAPath
{
    $p = RAPath::initWithRect(new NSRect(1, 1, 20, 20));
    $p->moveToY(0, 0);
    $p->quadToY1X2Y2(10, 30, 20, 0);
    $p->cubicToY1X2Y2X3Y3(30, 30, 40, -10, 50, 10);
    $p->close();

    return $p;
}

function fixture(string $class, ?RAScene $scene): object
{
    $red = RAPaint::initWithRedGreenBlueAlpha(1, 0, 0, 1);

    return match ($class) {
        'CGAffineTransform' => new CGAffineTransform(1, 0, 0, 1, 0, 0),
        'RAPaint' => $red,
        'RAPath' => busyPath(),
        'RADraw' => RADraw::initWithPathCtmColor(busyPath(), new CGAffineTransform(1, 0, 0, 1, 0, 0), $red),
        'RAScene' => $scene,
        'RASceneList' => RASceneList::initWithScene($scene),
        'RasterizerView' => RasterizerView::initWithFrame(new NSRect(0, 0, 32, 32)),
        'NSRect' => new NSRect(0, 0, 10, 10),
        'NSPoint' => new NSPoint(1, 2),
        'NSRange' => new NSRange(0, 3),
        'NSURL' => NSURL::fileURLWithPath(__FILE__),
        'NSAttributedString' => NSAttributedString::initWithStringAttributes('Sweep', []),
        'CGColor' => NSColor::colorWithRedGreenBlueAlpha(0, 0, 1, 1)->CGColor(),
        'CGImage' => CGImage::create(1, 1, 8, 32, 4, CGColorSpace::createWithName(kCGColorSpaceSRGB), kCGImageAlphaPremultipliedLast,
            CGDataProvider::createWithCFData(CFData::create(null, "\xff\x00\x00\xff", 4)), null, false, 0),
        'CFType' => CFAllocator::getDefault(),
        'NSObject' => new ObjCDelegate('RASceneListDelegate'),
        default => throw new LogicException("no fixture for $class"),
    };
}

/** One argument for $param in variant $v; the variant only changes values whose type has edge cases. */
function argument(ReflectionParameter $param, int $v, RAScene $scene): mixed
{
    $type = $param->getType();
    $name = $type instanceof ReflectionNamedType ? $type->getName() : 'mixed';

    return match (true) {
        $name === 'float' => floatArg($v),
        $name === 'int' => intArg($v),
        $name === 'bool' => (bool) ($v & 1),
        $name === 'array' => in_array($param->getName(), ['colors'], true)
            ? [[], [RAPaint::init()], [RAPaint::init(), RAPaint::init()], array_fill(0, 3, RAPaint::init()), [RAPaint::init(), RAPaint::init()]][$v]
            : numberList($v),
        $name === 'callable' => fn (int $i, RADraw $d) => [false, true, null, true, false][$v] ?? false,
        $name === 'NSRect' => rect($v),
        $name === 'CGAffineTransform' => transform($v),
        $name === 'NSRange' => [new NSRange(0, 0), new NSRange(5, 100), new NSRange(PHP_INT_MAX, 1), new NSRange(0, PHP_INT_MAX), new NSRange(1, 1)][$v],
        $name === 'NSURL' => [NSURL::fileURLWithPath(__FILE__), NSURL::fileURLWithPath('/nonexistent.svg'), NSURL::URLWithString('https://example.invalid/x.pdf'),
            NSURL::fileURLWithPath('/dev/null'), NSURL::fileURLWithPath(sys_get_temp_dir())][$v],
        enum_exists($name) => $name::cases()[$v % count($name::cases())],
        $type?->allowsNull() && $v === 4 => null,
        default => fixture($name, $scene),
    };
}

/** Renders $scene through both of RasterizerView's paths, off-screen. */
function render(RAScene $scene): void
{
    foreach ([false, true] as $cg) {
        $delegate = new ObjCDelegate('RASceneListDelegate');
        $delegate->on('getListAtTime:scale:width:height:', fn () => RASceneList::initWithScene($scene));
        $view = RasterizerView::initWithFrame(new NSRect(0, 0, 32, 32));
        $view->setUseCG($cg);
        $view->setListDelegate($delegate);
        $view->setNeedsDisplay(true);
        $view->displayIfNeeded();
        usleep(50000);
    }
}

function one(string $spec): void
{
    $cut = strrpos($spec, ':');
    [$method, $v] = [substr($spec, 0, $cut), substr($spec, $cut + 1)];
    [$class, $name] = explode('::', $method);
    $v = (int) $v;
    $ref = new ReflectionMethod($class, $name);

    $scene = RAScene::init();
    $scene->addDraw(RADraw::initWithPathCtmColor(busyPath(), new CGAffineTransform(1, 0, 0, 1, 0, 0), RAPaint::initWithGrayAlpha(0, 1)));

    try {
        $args = array_map(fn ($p) => argument($p, $v, $scene), $ref->getParameters());
        $receiver = $ref->isStatic() ? null : fixture($class, $scene);
        $result = $ref->invokeArgs($receiver, $args);

        /* Whatever the call made or changed goes into the scene, then the scene is drawn. */
        foreach ([$receiver, $result] as $made) {
            if ($made instanceof RAPath) {
                $scene->addFillCtmColorEvenOddClipClipPathBlendMode($made, new CGAffineTransform(1, 0, 0, 1, 0, 0), RAPaint::initWithGrayAlpha(0, 1), false, new NSRect(INF, INF, 0, 0), null, RABlendMode::NORMAL);
                $scene->addStrokeCtmColorWidthCapStyleJoinStyleClipClipPathBlendMode($made, new CGAffineTransform(1, 0, 0, 1, 0, 0), RAPaint::initWithGrayAlpha(0, 1), 2, RACapStyle::ROUND, RAJoinStyle::MITER, new NSRect(INF, INF, 0, 0), null, RABlendMode::NORMAL);
            } elseif ($made instanceof RADraw) {
                $scene->addDraw($made);
            } elseif ($made instanceof RAPaint) {
                $scene->addFillCtmColorEvenOddClipClipPathBlendMode(busyPath(), new CGAffineTransform(1, 0, 0, 1, 0, 0), $made, false, new NSRect(INF, INF, 0, 0), null, RABlendMode::NORMAL);
                $scene->addImageCtm($made, new CGAffineTransform(1, 0, 0, 1, 0, 0));
            }
        }
    } catch (Throwable $e) {
        /* A PHP exception is the binding answering; the render below still runs. */
        if (getenv('SWEEP_DEBUG')) {
            echo get_class($e), ': ', $e->getMessage(), "\n";
        }
    }
    render($scene);
}

if (($argv[1] ?? null) === '--one') {
    one($argv[2]);
    exit(0);
}

$specs = [];
foreach (CLASSES as $class) {
    foreach ((new ReflectionClass($class))->getMethods() as $m) {
        if ($m->getDeclaringClass()->getName() !== $class) {
            continue;
        }
        for ($v = 0; $v < VARIANTS; $v++) {
            $specs[] = "$class::{$m->getName()}:$v";
        }
    }
}

$fails = [];
$cwd = sys_get_temp_dir().'/mindbrix-sweep-'.getmypid();
@mkdir($cwd);
foreach ($specs as $spec) {
    $p = proc_open([PHP_BINARY, '-d', 'memory_limit=512M', __FILE__, '--one', $spec], [1 => ['file', '/dev/null', 'w'], 2 => ['file', '/dev/null', 'w']], $pipes, $cwd);
    $start = microtime(true);
    while (($s = proc_get_status($p))['running'] && microtime(true) - $start < 15) {
        usleep(2000);
    }
    if ($s['running']) {
        proc_terminate($p, 9);
        $fails[] = "$spec hang";
    } elseif ($s['signaled'] || $s['exitcode'] !== 0) {
        $fails[] = "$spec ".($s['signaled'] ? 'signal '.$s['termsig'] : 'exit '.$s['exitcode']);
    }
    proc_close($p);
}
@rmdir($cwd);
echo count($specs), ' calls, ', count($fails), " failures\n", implode("\n", $fails), "\n";
exit($fails === [] ? 0 : 1);
