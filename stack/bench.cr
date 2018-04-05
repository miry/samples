require "benchmark"
require "./stack"
require "./stack_linked_list"

size = 10000
r = Random.new
values = Array(String).new(size) { |i| r.rand(size).to_s }

arr = Stack.new
list = StackLinkedList.new

Benchmark.ips do |x|
  x.report("array") { values.each {|i| arr.push(i) } }
  x.report("list") { values.each {|i| list.push(i) } }
end

# crystal stack/bench.cr --release
# array   2.42M (412.99ns) (±16.29%)          fastest
#  list   79.9  ( 12.51ms) (±15.10%) 30303.45× slower
