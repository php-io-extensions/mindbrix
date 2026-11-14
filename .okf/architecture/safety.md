---
type: Architecture
title: Safety and threads
description: What Rasterizer guards itself, how exceptions, bailouts and threads are handled, and the file-reading caveat.
resource: src/RasterizerAPI.m
tags: [mindbrix, security, threads]
status: draft
generated: { by: claude-opus/5.5, at: 2026-11-13T02:00:00Z }
---

# Safety and threads

Refusal rule: appkit's (memory unsafety, uncatchable death, VM corruption, each with a probe). mindbrix keeps one refusal family: non-finite geometry (below).

Rasterizer guards itself:
- An `RADraw` kept past an update block is detached (`setTarget:nullptr`): it edits its own draw.
- Adding to a scene during an update raises NSInternalInconsistencyException → `AppKitException`.
- Update ranges are clamped; mismatched gradient counts and `<2` dash lengths are ignored.
- Enum values reach Rasterizer only through PHP enums (no out-of-range blend mode).

The binding:
- Update block: no PHP entered once an exception is pending (remaining draws answer NO); a bailout is caught in the block and resumed after Rasterizer returns, never unwinding its frames.
- Wrong-typed arrays, unset value-class properties, non-CGPath CF types: `TypeError`/`ValueError` before the call.
- Only `get_module` exported.

Threads: `RasterizerView` methods gated to the main thread. Display link and `-display` run on the main thread, so the delegate enters PHP on its own thread. Metal completion handlers run elsewhere and call no PHP.

Files: SVG/PDF loaders read NSURL paths without `open_basedir`, like appkit's other NSURL readers (SECURITY.md).

Crash sweep: before the fix, 425 calls, no crash, 3 hangs, all the one upstream bug below. See [build runbook](/runbooks/build.md).

# Curve subdivision

Upstream bug (found by the sweep, 2026-11-13): `GeometryWriter::Cubic` and `::Quadratic` keep their subdivision count in a float and loop `while (--count)`. NaN, infinite, or above-2^24 counts never reach 0 (INF/NaN coordinates, or Metal-path device coordinates from about 1e19 whose squares overflow float): the display never returns and memory grows until the process is killed.

Fixed both ways (Angel's decision):
- Vendored patch, 7 lines in `Rasterizer.hpp`: such a count becomes 1, the curve drawn as one piece; terminating counts untouched. The only difference from upstream; Angel offers it upstream.
- Binding refusals (`ValueError`) for non-finite path coordinates, shape rects, corner sizes, transform fields, stroke widths, dash phase and lengths. Clip rects exempt (`CGRectNull`).

Sweep after the fix: 425 calls, 0 failures. Held by `tests/FiniteGeometryTest.php` (refusals, and a 1e20-scale curve drawn on both paths in a child with a deadline).
