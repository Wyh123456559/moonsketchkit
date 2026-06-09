///|
/// Entry point for the CLI or runnable program in this template.
/// Keep main focused; move logic into the library package.
/// Run with `moon run cmd/main` from the project root.
fn main {
  let filter = @moonsketchkit.BloomFilter::new(64, 3)
  filter.add(42)
  filter.add(7)
  println("MoonSketchKit demo")
  println("bloom might contain 42: \{filter.might_contain(42)}")
  println("bloom might contain 99: \{filter.might_contain(99)}")
  println("bloom json: \{filter.to_json()}")

  let counting = @moonsketchkit.CountingBloomFilter::new(64, 3)
  counting.add(42)
  counting.add(42)
  counting.remove(42)
  println("counting bloom might contain 42: \{counting.might_contain(42)}")
  println("counting bloom json: \{counting.to_json()}")

  let sketch = @moonsketchkit.CountMinSketch::new(32, 4)
  sketch.add_count(42, 5)
  sketch.add_count(7, 2)
  println("count estimate 42: \{sketch.estimate(42)}")
  println("count estimate 7: \{sketch.estimate(7)}")
  println("sketch json: \{sketch.to_json()}")
}
