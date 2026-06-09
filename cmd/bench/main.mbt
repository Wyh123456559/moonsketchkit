///|
/// Run with `moon run cmd/bench` from the project root.
fn main {
  println("scenario,structure,metric,value")
  run_bloom_small()
  run_counting_bloom()
  run_count_min()
}

///|
fn print_metric(
  scenario : String,
  structure : String,
  metric : String,
  value : Int
) -> Unit {
  println("\{scenario},\{structure},\{metric},\{value}")
}

///|
fn run_bloom_small() -> Unit {
  let filter = @moonsketchkit.BloomFilter::new(128, 3)
  filter.add_all([1, 2, 3, 5, 8, 13, 21, 34])
  print_metric("small-sequence", "bloom", "set_bits", filter.bit_count())
  print_metric("small-sequence", "bloom", "load_per_mille", filter.load_per_mille())
}

///|
fn run_counting_bloom() -> Unit {
  let filter = @moonsketchkit.CountingBloomFilter::new(128, 3)
  filter.add(42)
  filter.add(42)
  filter.add(7)
  filter.remove(42)
  print_metric("duplicate-removal", "counting_bloom", "nonzero", filter.nonzero_count())
  print_metric(
    "duplicate-removal",
    "counting_bloom",
    "contains_42",
    if filter.might_contain(42) { 1 } else { 0 },
  )
}

///|
fn run_count_min() -> Unit {
  let sketch = @moonsketchkit.CountMinSketch::new(64, 4)
  sketch.add_count(42, 5)
  sketch.add_count(7, 2)
  sketch.add_count(42, 3)
  print_metric("frequency", "count_min", "estimate_42", sketch.estimate(42))
  print_metric("frequency", "count_min", "estimate_7", sketch.estimate(7))
}

