///|
/// Counting Bloom filter for integer keys.
pub(all) struct CountingBloomFilter {
  size : Int
  hash_count : Int
  counts : Array[Int]
} derive(Eq, Debug)

///|
pub fn CountingBloomFilter::new(size : Int, hash_count : Int) -> CountingBloomFilter {
  let normalized_size = normalized_positive(size, default_bloom_size)
  let normalized_hash_count = normalized_positive(hash_count, default_hash_count)
  {
    size: normalized_size,
    hash_count: normalized_hash_count,
    counts: Array::make(normalized_size, 0),
  }
}

///|
pub fn CountingBloomFilter::add(self : CountingBloomFilter, value : Int) -> Unit {
  for seed = 0; seed < self.hash_count; seed = seed + 1 {
    let index = sketch_hash(value, seed, self.size)
    self.counts[index] = self.counts[index] + 1
  }
}

///|
pub fn CountingBloomFilter::remove(self : CountingBloomFilter, value : Int) -> Unit {
  if !self.might_contain(value) {
    return
  }
  for seed = 0; seed < self.hash_count; seed = seed + 1 {
    let index = sketch_hash(value, seed, self.size)
    if self.counts[index] > 0 {
      self.counts[index] = self.counts[index] - 1
    }
  }
}

///|
pub fn CountingBloomFilter::might_contain(
  self : CountingBloomFilter,
  value : Int
) -> Bool {
  for seed = 0; seed < self.hash_count; seed = seed + 1 {
    let index = sketch_hash(value, seed, self.size)
    if self.counts[index] <= 0 {
      return false
    }
  }
  true
}

///|
pub fn CountingBloomFilter::nonzero_count(self : CountingBloomFilter) -> Int {
  let mut count = 0
  for i = 0; i < self.counts.length(); i = i + 1 {
    if self.counts[i] > 0 {
      count = count + 1
    }
  }
  count
}

///|
pub fn CountingBloomFilter::to_json(self : CountingBloomFilter) -> String {
  "{\"type\":\"counting_bloom_filter\",\"size\":\{self.size},\"hash_count\":\{self.hash_count},\"nonzero_counters\":\{self.nonzero_count()}}"
}
