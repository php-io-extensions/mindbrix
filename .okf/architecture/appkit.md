---
type: Architecture
title: On appkit
description: How mindbrix's classes ride ext-appkit's object model, delegate and callback glue.
resource: src/RasterizerAPI.m
tags: [mindbrix, appkit]
status: draft
generated: { by: claude-opus/5.5, at: 2026-11-13T00:00:00Z }
---

# On appkit

- `ZEND_MOD_REQUIRED("appkit")`; compiled against appkit's installed `php_appkit_api.h`; `30-mindbrix.ini` loads after `30-appkit.ini`.
- Each class: `register_class_X(parent)`, `appkit_object_setup`, `appkit_map_objc_class`. Boxing finds them by Objective-C class, so `RADraw::path()` returns an `RAPath` and `RasterizerView::initWithFrame()` (appkit's NSView method) makes a RasterizerView.
- Bodies in `APPKIT_BEGIN`/`APPKIT_END`: NSException → `AppKitException`. Inits: `[[called alloc] init…]`, boxed, released.
- Binding is manual retain/release Objective-C; vendored Objective-C++ is ARC, C++17, as upstream.
- List delegate: appkit's `ObjCDelegate('RASceneListDelegate')`. MINIT references `@protocol(RASceneListDelegate)` so the runtime has it (nothing in the binary adopts it). The view holds it weakly.
- Update block (`RADrawUpdateBlock`, NS_NOESCAPE): a block calling the PHP callable inline; see [safety](/architecture/safety.md).
- No CGPath class: appkit's `CFType::fromPointer()` boxes only CF types it lists, so one could never be produced; `CFType` + TypeID check instead.
