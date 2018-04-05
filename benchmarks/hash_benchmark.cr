require "benchmark"

size = 10000
r = Random.new
indexes = Array(Int32).new(size) { |i| r.rand(size) }

arr = [] of Int32 
hash = {} of Int32 => Int32

size.times do |i|
  arr << i
  hash[i] = i
end

Benchmark.ips do |x|
  x.report("array") { indexes.each {|i| arr[i] } }
  x.report("hash") { indexes.each {|i| hash[i] } }
end
