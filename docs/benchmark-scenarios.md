# Benchmark Scenarios

MoonSketchKit includes a deterministic benchmark-style command for recording
basic structure behavior across commits.

Run it from the repository root:

```sh
moon run cmd/bench
```

The output is CSV-like:

```text
scenario,structure,metric,value
small-sequence,bloom,set_bits,23
```

## Included Scenarios

- `small-sequence`: inserts a fixed integer sequence into a Bloom filter.
- `duplicate-removal`: checks duplicate handling in a Counting Bloom filter.
- `frequency`: records Count-Min Sketch estimates for fixed frequencies.

## Review Notes

- Values are deterministic for the current hash helper.
- The command is not a microbenchmark; it is a reproducible behavior baseline.
- Add a row whenever a new sketch or workload is introduced.
