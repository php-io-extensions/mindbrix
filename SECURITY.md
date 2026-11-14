# Security Policy

## Supported versions

ext-mindbrix is pre-1.0. No 0.x release receives security fixes or advisories; fixes land in the
next release line. Security support starts with 1.0.

| Version | Security fixes |
|---------|----------------|
| < 1.0   | No             |

## Reporting a vulnerability

Please don't open a public issue for a security problem.

Report it privately through GitHub: the **Report a vulnerability** button on the
[php-io-extensions/mindbrix](https://github.com/php-io-extensions/mindbrix) repository's **Security** tab.
If that isn't available, email **info@projectsaturnstudios.com**.

Include what you found, the affected version, your macOS version and Mac, PHP build (NTS or ZTS),
and steps to reproduce (`php --ri mindbrix` shows the extension version and the Rasterizer commit
it carries).

A defect in mindbrix/Rasterizer itself belongs with that project. Report it here as well when
ext-mindbrix should guard against it.

## Security model

- **Objects.** Every Rasterizer object is an ext-appkit object: retained while PHP holds it,
  released when PHP lets go, never freed under a live wrapper. An `RADraw` handed to an update block
  is the scene's draw only during that call; Rasterizer detaches one kept afterwards, so it edits
  its own copy, not freed scene memory.
- **Exceptions.** An Objective-C exception Rasterizer raises (adding to a scene while its draws are
  being updated) is caught inside the call and becomes `AppKitException`; none unwinds through PHP.
- **Callbacks.** The update block's callable runs inline on the calling thread. The list delegate is
  called from the view's display on the main thread, which is PHP's thread under AppKit. No PHP runs
  on Metal's threads.
- **Files.** `addSvgFromUrl()`, `addPdfFromUrlPageIndex()` and `pdfPageCountFromUrl()` read the
  file an `NSURL` names with Rasterizer's own parsers (NanoSVG, and Rasterizer's PDF reader). Like
  ext-appkit's other NSURL readers, they do not apply PHP's `open_basedir`: do not pass untrusted
  paths in a sandboxed deployment. A crafted SVG or PDF is parsed by vendored C/C++ that has not
  been audited here; the crash sweep (`tools/sweep.php`) feeds it only missing, empty and
  non-document files.
- **Curve subdivision.** Upstream Rasterizer (2be4bc16) loops forever, growing memory until the
  process is killed, on non-finite curve geometry: INF or NaN coordinates, or Metal-path device
  coordinates from about 1e19. ext-mindbrix fixes the loop in its vendored copy and also refuses
  non-finite geometry at the binding (`ValueError`). Details in `.okf/architecture/safety.md`.
- **Shaders.** The Metal shaders are compiled at run time from source compiled into the extension
  (`src/shaders.inc`); nothing is loaded from disk.
