///|
test "bloom filter reports inserted values" {
  let filter = @moonsketchkit.BloomFilter::new(64, 3)
  filter.add(42)
  filter.add(7)
  assert_true(filter.might_contain(42))
  assert_true(filter.might_contain(7))
  assert_false(filter.might_contain(99))
  assert_true(filter.bit_count() > 0)
}

///|
test "bloom filter can be cleared" {
  let filter = @moonsketchkit.BloomFilter::new(64, 3)
  filter.add(123)
  assert_true(filter.might_contain(123))
  filter.clear()
  assert_false(filter.might_contain(123))
  assert_eq(filter.bit_count(), 0)
}

///|
test "bloom filter normalizes invalid options" {
  let filter = @moonsketchkit.BloomFilter::new(0, 0)
  filter.add(1)
  assert_eq(filter.size, 128)
  assert_eq(filter.hash_count, 3)
  assert_true(filter.might_contain(1))
}

///|
test "bloom filter exports summary json" {
  let filter = @moonsketchkit.BloomFilter::new(32, 2)
  filter.add(5)
  let json = filter.to_json()
  assert_true(json.contains("\"type\":\"bloom_filter\""))
  assert_true(json.contains("\"size\":32"))
  assert_true(json.contains("\"hash_count\":2"))
}

///|
test "count min sketch estimates inserted counts" {
  let sketch = @moonsketchkit.CountMinSketch::new(32, 4)
  sketch.add(10)
  sketch.add_count(10, 4)
  sketch.add_count(20, 2)
  assert_eq(sketch.estimate(10), 5)
  assert_eq(sketch.estimate(20), 2)
  assert_eq(sketch.estimate(30), 0)
}

///|
test "count min sketch ignores non positive counts" {
  let sketch = @moonsketchkit.CountMinSketch::new(16, 3)
  sketch.add_count(8, 0)
  sketch.add_count(8, -2)
  assert_eq(sketch.estimate(8), 0)
}

///|
test "count min sketch can be cleared" {
  let sketch = @moonsketchkit.CountMinSketch::new(16, 3)
  sketch.add_count(5, 9)
  assert_eq(sketch.estimate(5), 9)
  sketch.clear()
  assert_eq(sketch.estimate(5), 0)
}

///|
test "count min sketch exports summary json" {
  let sketch = @moonsketchkit.CountMinSketch::new(12, 3)
  let json = sketch.to_json()
  assert_true(json.contains("\"type\":\"count_min_sketch\""))
  assert_true(json.contains("\"width\":12"))
  assert_true(json.contains("\"depth\":3"))
  assert_true(json.contains("\"cells\":36"))
}
