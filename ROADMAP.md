# MoonSketchKit Roadmap

MoonSketchKit is planned as a reusable MoonBit library for probabilistic data
structures and stream-friendly approximate algorithms.

## Completed Foundation

- MoonBit package skeleton.
- Integer Bloom filter.
- Counting Bloom filter.
- Integer Count-Min Sketch.
- Deterministic hash helper.
- JSON summary export.
- CLI demo and tests.

## Near-Term Work

1. Stable String Hashing

   Add string-key support without relying on platform-specific APIs.

2. Benchmark Notes

   Record false-positive behavior and Count-Min Sketch estimation stability
   across deterministic workloads.

3. Serialization

   Add import/export helpers so sketches can be persisted or compared.

## Non-Goals For The First Contest Version

- Cryptographic hashing.
- Large external dependencies.
- Networked storage or database integration.
- Platform-specific IO in the core library.
