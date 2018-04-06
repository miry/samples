require "benchmark"

def hashtable_benchmark(size : Int32)
  r = Random.new
  indexes = Array(Int32).new(size) { |i| r.rand(size) }
  
  arr = [] of Int32 
  hash = {} of Int32 => Int32
  
  size.times do |i|
    arr << i
    hash[i] = i
  end
  
  Benchmark.ips(warmup: 2, calculation: 10) do |x|
    Array(Int32).new(10) { |i| r.rand(size) }.each do |indx|
      x.report("hash #{indx}") { hash[indx] }
      x.report("array #{indx}") { arr[indx] }
    end
  end

  step = size / 10
  Benchmark.bm do |x|
    1.upto(10) do |i|
      r = i * step
      r = r.as(Int32)
      x.report("hash #{r}") { r.as(Int32).times {|i| hash[indexes[i]] } }
      x.report("array #{r}") { r.as(Int32).times {|i| arr[indexes[i]] } }
    end
  end
end

hashtable_benchmark(50_000)