# Changelog

All notable changes to MoonSketchKit are recorded here.

## 0.1.0 - 2026-06-09

### Added

- Initialized the MoonBit package.
- Added integer `BloomFilter`.
- Added `CountingBloomFilter`.
- Added integer `CountMinSketch`.
- Added bulk insert helpers for Bloom filter and Count-Min Sketch.
- Added merge helpers for compatible Bloom filters and Count-Min Sketches.
- Added JSON summary export helpers.
- Added CLI demo and tests.
- Added deterministic benchmark-style command and scenario notes.
- Added accuracy notes for false positives and frequency estimates.
- Expanded the CLI demo to include Counting Bloom filter behavior.

### Verified

- `moon check`
- `moon test`
- `moon run cmd/main`
