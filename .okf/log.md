# Log

- 2026-11-20: synced lib/Rasterizer to mindbrix/Rasterizer `fixes` @ 58ffc36 (NanoSVG clip-cache hashing and parse-depth cap; RasterizerAPI.h unchanged). GeometryWriter curve-subdivision patch re-kept as the only vendored diff; Outliner::Cubic hang still unpatched.
- 2026-11-19: CI on `fixes` @ 2f57db8: Metal stroke of a 1e20-scale cubic hangs in new `Outliner::Cubic` (`for (i = 1; i <= m; i++)` with Inf `m`); not patched (one-patch rule). FiniteGeometryTest now fills, which hits the GeometryWriter guard; child deadline 60 s for cold shader compile.
- 2026-11-19: synced lib/Rasterizer to mindbrix/Rasterizer `fixes` @ 2f57db8 (31 commits ahead of 2be4bc16); rebound `RAPath::writeToCGPath`, `RAJoinStyle::BEVEL`, documented negative width as device width; shaders.inc regenerated; curve-subdivision patch re-applied (still absent upstream).
- 2026-11-13: curve-subdivision hang fixed both ways: 7-line patch in vendored Rasterizer.hpp (offered upstream) and ValueError for non-finite geometry; FiniteGeometryTest added.
- 2026-11-13: crash sweep: 425 calls, no crash, 3 hangs from one upstream bug (float-counter curve subdivision on non-finite geometry); recorded in architecture/safety.md, fix pending a decision.
- 2026-11-13: ext-mindbrix built: Rasterizer 2be4bc16 vendored unchanged, shaders compiled at run time, 85 methods bound, Pest green on php84 NTS + ZTS (32 tests).
