<?php

declare(strict_types=1);

/*
 * Builds tests/native/render.mm from the extension's own sources, compiled with the flags
 * config.m4 uses, and checks the pixels both of RasterizerView's paths draw off-screen.
 * This is what proves the shader adaptation (src/prelude.h, src/shaders.inc) renders.
 */

function nativeRenderOutput(): array
{
    static $lines = null;
    if ($lines !== null) {
        return $lines;
    }

    $root = dirname(__DIR__);
    $ra = $root.'/lib/Rasterizer/Package/Sources';
    $dir = sys_get_temp_dir().'/mindbrix-render-'.getmypid();
    @mkdir($dir);
    register_shutdown_function(static fn () => exec('rm -rf '.escapeshellarg($dir)));

    $inc = sprintf('-I%1$s/RasterizerCpp/include -I%1$s/RasterizerObjC/include -I%1$s/RasterizerObjC/private -I%2$s/src', escapeshellarg($ra), escapeshellarg($root));
    $mm = '-x objective-c++ -std=c++17 -fobjc-arc -fobjc-exceptions -O2 -w';
    $steps = [
        "clang -x c -O2 -w -c $ra/RasterizerCpp/xxhash.c $inc -o $dir/xxhash.o",
        "clang++ -x c++ -std=c++17 -O2 -w -c $ra/RasterizerCpp/nanosvg.cc $inc -o $dir/nanosvg.o",
        "clang -x objective-c -fno-objc-arc -O2 -c $root/src/shaders.m $inc -o $dir/shaders.o",
        "clang++ $mm -c $ra/RasterizerObjC/RasterizerAPI.mm $inc -o $dir/api.o",
        "clang++ $mm -include $root/src/prelude.h -c $ra/RasterizerObjC/RasterizerLayer.mm $inc -o $dir/layer.o",
        "clang++ $mm -c $ra/RasterizerObjC/RasterizerView.mm $inc -o $dir/view.o",
        "clang++ $mm -c $root/tests/native/render.mm $inc -o $dir/render.o",
        "clang++ -fobjc-arc $dir/*.o -framework Cocoa -framework Metal -framework QuartzCore -framework CoreText -o $dir/render",
    ];
    foreach ($steps as $step) {
        exec($step.' 2>&1', $out, $code);
        $code === 0 || throw new RuntimeException("native build failed: $step\n".implode("\n", $out));
    }

    exec(escapeshellarg("$dir/render").' 2>/dev/null', $out, $code);
    $code === 0 || throw new RuntimeException('render failed: '.implode("\n", $out));

    $lines = [];
    foreach ($out as $line) {
        $parts = explode(' ', $line);
        $name = array_shift($parts);
        foreach ($parts as $part) {
            [$at, $rgba] = explode('=', $part);
            $lines[$name][$at] = array_map('intval', explode(',', $rgba));
        }
    }

    return $lines;
}

dataset('render paths', ['metal', 'cg']);

it('draws the red square on white', function (string $path) {
    $px = nativeRenderOutput()[$path];

    $white = [255, 255, 255, 255];
    $red = [255, 0, 0, 255];
    expect($px['2,2'])->toBe($white)
        ->and($px['17,17'])->toBe($red)
        ->and($px['32,32'])->toBe($red)
        ->and($px['47,47'])->toBe($red)
        ->and($px['50,50'])->toBe($white)
        ->and($px['61,2'])->toBe($white);
})->with('render paths');
