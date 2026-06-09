# Accuracy Notes

MoonSketchKit contains probabilistic data structures. They trade exactness for
compact memory and fast updates.

## Bloom Filter

Bloom filters never produce false negatives for inserted values unless the
filter is cleared or rebuilt incorrectly. They can produce false positives:
`might_contain(value)` can return true for a value that was never inserted.

The false-positive rate depends on:

- bit array size
- number of hash functions
- number of inserted values
- hash distribution

The current API exposes `bit_count` and `load_per_mille` so examples and tests
can track how full the filter is.

## Counting Bloom Filter

Counting Bloom filters replace bits with counters. This allows remove-like
workflows, but the same false-positive caveat still applies. Removing values
that were never inserted is ignored by the current implementation.

## Count-Min Sketch

Count-Min Sketch estimates frequencies. Estimates are never below the stored
count for the same hash layout, but collisions can make estimates higher than
the exact count.

The current integer-key implementation is deterministic, which keeps examples
and benchmark notes reproducible across commits.

