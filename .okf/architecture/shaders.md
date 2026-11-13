---
type: Architecture
title: Shaders
description: Rasterizer's Metal library is compiled from source at run time, through a prelude scoped to RasterizerLayer.mm.
resource: src/prelude.h
tags: [mindbrix, metal, build]
status: draft
generated: { by: claude-opus/5.5, at: 2026-11-13T00:00:00Z }
sources:
  - id: layer-mm
    resource: lib/Rasterizer/Package/Sources/RasterizerObjC/RasterizerLayer.mm
    title: RasterizerLayer.mm
---

# Shaders

Problem: `RasterizerLayer -init` builds all pipelines from `-[MTLDevice newDefaultLibrary]` outside SwiftPM[^layer-mm], which reads `default.metallib` from the main bundle. PHP has none, and Command Line Tools ship no offline `metal` compiler.

Route, upstream untouched:

1. `tools/shaders.php` writes `src/shaders.inc`: `Shaders.metal` with its one import, `Rasterizer.h`, inlined, as a C string. `tests/ShadersTest.php` fails while stale.
2. `src/prelude.h`, force-included (`-include`) into `RasterizerLayer.mm` only: imports Metal, then `#define newDefaultLibrary newLibraryWithSource:mindbrix_shader_source() options:nil error:nil`. Metal's own declaration is read first, so only upstream's call site changes; both are "new"-family (+1), ARC ownership unchanged.
3. `src/shaders.m` returns the NSString.

Measured: first layer 896 ms (full compile), later 67 ms (OS shader cache). 13 pipeline states + library non-nil; off-screen pixels correct (see [build runbook](/runbooks/build.md)).

After updating `lib/Rasterizer`: `php tools/shaders.php`, rebuild, run the native render check.
