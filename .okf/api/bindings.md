---
type: API Reference
title: Bindings
description: Every class, selector and enum of Rasterizer's public headers as PHP, and the naming rules.
resource: stubs/RasterizerAPI.stub.php
tags: [mindbrix, rasterizer, api]
status: draft
generated: { by: claude-opus/5.5, at: 2026-11-13T00:00:00Z }
sources:
  - id: api-h
    resource: lib/Rasterizer/Package/Sources/RasterizerObjC/include/RasterizerAPI.h
    title: RasterizerAPI.h
  - id: view-h
    resource: lib/Rasterizer/Package/Sources/RasterizerObjC/include/RasterizerView.h
    title: RasterizerView.h
---

# Bindings

Bound: all of `RasterizerAPI.h`[^api-h] and `RasterizerView.h`[^view-h]. Not bound: the C++ core (`Ra::`), not public API.

| Class | Methods |
|---|---|
| `RAPaint extends NSObject` | `init`, gray/HSV/RGB/CGColor/CGImage inits, linear and radial gradients (8) |
| `RAPath extends NSObject` | `init`, rect/ellipse/rounded-rect/CGPath inits, segments, `close`, adds, `bounds`, `dashedCopyWithPhaseLengths` (16) |
| `RADraw extends NSObject` | `init`, `initWithPathCtmColor`, 12 property getter/setter pairs (26) |
| `RAScene extends NSObject` | `init`, `bounds`, `count`, `addDraw`, `addImageCtm`, fill, stroke, text, PDF count/import, SVG import, `updateDrawsInRangeUsingBlock` (12) |
| `RASceneList extends NSObject` | `init`, `initWithScene`, `bounds`, ctm, clear colour, four flags, `addList`, `addScene`, `addSceneCtmClip` (18) |
| `RasterizerView extends NSView` | `listDelegate`/`setListDelegate`, `useCG`/`setUseCG` (4); made with appkit's `initWithFrame` |
| `CGAffineTransform` | final value class `$a $b $c $d $tx $ty` (constructor) |

Enums `RACapStyle`, `RAJoinStyle`, `RABlendMode`: int-backed, cases upper case without prefix, values `_Static_assert`-checked.

# Naming

- One method per selector, keywords joined camelCase: `moveTo:y:` → `moveToY()`.
- `init…` static, returns the called class; `init()` is the inherited `-init` each class is made with upstream.
- Properties: getter = property name, setter = `set…`.

# Values

`CGRect` → appkit `NSRect`, `CGPoint` → `NSPoint`; appkit `NSRange`, `NSURL`, `NSAttributedString`, `CGColor`, `CGImage`. `CGPathRef` → appkit `CFType`, checked against `CGPathGetTypeID()`. `NSArray<RAPaint *>` → list of RAPaint; `NSArray<NSNumber *>` → list of int|float. `CGRectNull` = `new NSRect(INF, INF, 0, 0)`.

Geometry must be finite: non-finite path coordinates, shape rects, corner sizes, transform fields, stroke widths and dashes raise `ValueError` ([safety](/architecture/safety.md)).

Upstream behaviour passed through: a path's `bounds()` is empty until a scene validates it; `dashedCopy` with fewer than two lengths answers the path itself; mismatched gradient counts leave a default paint; `addImageCtm` ignores non-image paints.
