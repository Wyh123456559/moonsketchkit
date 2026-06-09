///|
let default_bloom_size = 128

///|
let default_hash_count = 3

///|
let default_sketch_width = 32

///|
let default_sketch_depth = 4

///|
fn positive_mod(value : Int, modulo : Int) -> Int {
  let remainder = value % modulo
  if remainder < 0 {
    remainder + modulo
  } else {
    remainder
  }
}

///|
fn normalized_positive(value : Int, fallback : Int) -> Int {
  if value > 0 {
    value
  } else {
    fallback
  }
}

///|
fn sketch_hash(value : Int, seed : Int, modulo : Int) -> Int {
  let mixed = value * 131 + seed * 1009 + seed * seed * 17 + 97
  positive_mod(mixed, modulo)
}

///|
/// A compact Bloom filter for integer keys.
pub(all) struct BloomFilter {
  size : Int
  hash_count : Int
  bits : Array[Bool]
} derive(Eq, Debug)

///|
pub fn BloomFilter::new(size : Int, hash_count : Int) -> BloomFilter {
  let normalized_size = normalized_positive(size, default_bloom_size)
  let normalized_hash_count = normalized_positive(hash_count, default_hash_count)
  {
    size: normalized_size,
    hash_count: normalized_hash_count,
    bits: Array::make(normalized_size, false),
  }
}

///|
pub fn BloomFilter::add(self : BloomFilter, value : Int) -> Unit {
  for seed = 0; seed < self.hash_count; seed = seed + 1 {
    let index = sketch_hash(value, seed, self.size)
    self.bits[index] = true
  }
}

///|
pub fn BloomFilter::add_all(self : BloomFilter, values : Array[Int]) -> Unit {
  for i = 0; i < values.length(); i = i + 1 {
    self.add(values[i])
  }
}

///|
pub fn BloomFilter::might_contain(self : BloomFilter, value : Int) -> Bool {
  for seed = 0; seed < self.hash_count; seed = seed + 1 {
    let index = sketch_hash(value, seed, self.size)
    if !self.bits[index] {
      return false
    }
  }
  true
}

///|
pub fn BloomFilter::clear(self : BloomFilter) -> Unit {
  for i = 0; i < self.bits.length(); i = i + 1 {
    self.bits[i] = false
  }
}

///|
pub fn BloomFilter::bit_count(self : BloomFilter) -> Int {
  let mut count = 0
  for i = 0; i < self.bits.length(); i = i + 1 {
    if self.bits[i] {
      count = count + 1
    }
  }
  count
}

///|
pub fn BloomFilter::load_per_mille(self : BloomFilter) -> Int {
  self.bit_count() * 1000 / self.size
}

///|
pub fn BloomFilter::to_json(self : BloomFilter) -> String {
  "{\"type\":\"bloom_filter\",\"size\":\{self.size},\"hash_count\":\{self.hash_count},\"set_bits\":\{self.bit_count()},\"load_per_mille\":\{self.load_per_mille()}}"
}

///|
/// Count-Min Sketch for approximate frequency counts of integer keys.
pub(all) struct CountMinSketch {
  width : Int
  depth : Int
  counts : Array[Int]
} derive(Eq, Debug)

///|
pub fn CountMinSketch::new(width : Int, depth : Int) -> CountMinSketch {
  let normalized_width = normalized_positive(width, default_sketch_width)
  let normalized_depth = normalized_positive(depth, default_sketch_depth)
  {
    width: normalized_width,
    depth: normalized_depth,
    counts: Array::make(normalized_width * normalized_depth, 0),
  }
}

///|
fn CountMinSketch::index(self : CountMinSketch, row : Int, value : Int) -> Int {
  row * self.width + sketch_hash(value, row, self.width)
}

///|
pub fn CountMinSketch::add(self : CountMinSketch, value : Int) -> Unit {
  self.add_count(value, 1)
}

///|
pub fn CountMinSketch::add_count(
  self : CountMinSketch,
  value : Int,
  count : Int
) -> Unit {
  if count <= 0 {
    return
  }
  for row = 0; row < self.depth; row = row + 1 {
    let index = self.index(row, value)
    self.counts[index] = self.counts[index] + count
  }
}

///|
pub fn CountMinSketch::estimate(self : CountMinSketch, value : Int) -> Int {
  let mut best = self.counts[self.index(0, value)]
  for row = 1; row < self.depth; row = row + 1 {
    let current = self.counts[self.index(row, value)]
    if current < best {
      best = current
    }
  }
  best
}

///|
pub fn CountMinSketch::clear(self : CountMinSketch) -> Unit {
  for i = 0; i < self.counts.length(); i = i + 1 {
    self.counts[i] = 0
  }
}

///|
pub fn CountMinSketch::cell_count(self : CountMinSketch) -> Int {
  self.width * self.depth
}

///|
pub fn CountMinSketch::to_json(self : CountMinSketch) -> String {
  "{\"type\":\"count_min_sketch\",\"width\":\{self.width},\"depth\":\{self.depth},\"cells\":\{self.cell_count()}}"
}
