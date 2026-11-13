---
type: Runbook
title: Build, install, test
description: Building ext-mindbrix on macOS, running Pest, the native render check and the crash sweep.
resource: install-macos.sh
tags: [mindbrix, build, test]
status: draft
generated: { by: claude-opus/5.5, at: 2026-11-13T00:00:00Z }
---

# Build, install, test

1. Install ext-appkit into the same PHP first.
2. `./install-macos.sh` → Homebrew `php@8.4` and `php@8.4-zts`; builds in a temp copy, signs ad hoc, writes `30-mindbrix.ini`.
3. `php --ri mindbrix` → version 0.11.0, Rasterizer `2be4bc16`.
4. `composer install && php -d memory_limit=128M vendor/bin/pest` on both PHPs (32 tests). Gate commits on Pest's exit code.

Nothing is shown on screen: views render off-screen via `displayIfNeeded()`.

`tests/NativeRenderTest.php` compiles `tests/native/render.mm` from the extension's own sources (clang, ~20 s) and checks Metal and Core Graphics pixels, which appkit cannot read back.

`php tools/sweep.php`: every method × 5 argument sets, one child each, then a render of the touched scene through both paths; `--one Class::method:N` reruns one, `SWEEP_DEBUG=1` prints the exception a call answered.

Not run: CI (`.github/workflows/ci.yml`; needs a runner with Metal), PIE install.
