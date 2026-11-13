<?php

declare(strict_types=1);

it('carries the shader source tools/shaders.php writes from lib/Rasterizer', function () {
    $root = dirname(__DIR__);
    $written = shell_exec(escapeshellarg(PHP_BINARY).' '.escapeshellarg($root.'/tools/shaders.php').' --print');

    expect($written)->toBe(file_get_contents($root.'/src/shaders.inc'));
});
