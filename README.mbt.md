# MoonSketchKit

MoonSketchKit is a MoonBit probabilistic data structure toolkit.

It focuses on compact approximate data structures that are useful for caching,
stream processing, telemetry, indexing, deduplication, and algorithm education.

## Status

This project is being prepared as a separate MoonBit ecosystem contest project.
It does not overlap with MoonNavKit, which focuses on path planning and search
visualization.

Current foundation:

- Integer Bloom filter
- Counting Bloom filter
- Integer Count-Min Sketch
- Deterministic internal hash helper
- JSON summary export
- CLI demo
- MoonBit tests

## Bloom Filter Example

```mbt
test {
  let filter = BloomFilter::new(64, 3)
  filter.add(42)
  filter.add(7)

  assert_true(filter.might_contain(42))
  assert_false(filter.might_contain(99))
}
```

## Counting Bloom Filter Example

```mbt
test {
  let filter = CountingBloomFilter::new(64, 3)
  filter.add(42)
  filter.add(42)
  filter.remove(42)

  assert_true(filter.might_contain(42))
}
```

## Count-Min Sketch Example

```mbt
test {
  let sketch = CountMinSketch::new(32, 4)
  sketch.add_count(42, 5)
  sketch.add_count(7, 2)

  assert_eq(sketch.estimate(42), 5)
  assert_eq(sketch.estimate(7), 2)
}
```

## Commands

```sh
moon check
moon test
moon run cmd/main
```

## Roadmap

- Counting Bloom filter
- Merge helpers for distributed sketches
- Stable string hashing support
- HyperLogLog-style cardinality sketch
- Serialization and import helpers
- Benchmark scenarios and false-positive notes
