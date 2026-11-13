---
okf_version: "0.2"
---

# ext-mindbrix

1:1 PHP bindings of mindbrix/Rasterizer (commit 2be4bc16, its 0.1.0; vendored, unchanged), a Metal vector renderer, on ext-appkit's object model. Version 0.11.0. macOS 14+ only. PHP 8.4 NTS + ZTS.

# API

* [Bindings](api/bindings.md) — 85 methods over RAPaint, RAPath, RADraw, RAScene, RASceneList, RasterizerView; three enums; CGAffineTransform.

# Architecture

* [Shaders](architecture/shaders.md) — why and how the Metal library is compiled from source at run time.
* [On appkit](architecture/appkit.md) — object model, value classes, the list delegate, the update block.
* [Safety and threads](architecture/safety.md) — what Rasterizer guards itself, exceptions, bailouts, threads, files.

# Runbooks

* [Build, install, test](runbooks/build.md) — Mac NTS/ZTS, the native render check, the crash sweep.
