<?php

declare(strict_types=1);

it('loads after appkit at the framework version line', function () {
    expect(phpversion('mindbrix'))->toBe('0.11.0')
        ->and(extension_loaded('appkit'))->toBeTrue();
});
