# Log

- 2026-11-13: curve-subdivision hang fixed both ways: 7-line patch in vendored Rasterizer.hpp (offered upstream) and ValueError for non-finite geometry; FiniteGeometryTest added.
- 2026-11-13: crash sweep: 425 calls, no crash, 3 hangs from one upstream bug (float-counter curve subdivision on non-finite geometry); recorded in architecture/safety.md, fix pending a decision.
- 2026-11-13: ext-mindbrix built: Rasterizer 2be4bc16 vendored unchanged, shaders compiled at run time, 85 methods bound, Pest green on php84 NTS + ZTS (32 tests).
