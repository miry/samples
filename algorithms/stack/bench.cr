require "benchmark"
require "./stack"
require "./stack_linked_list"

size = 1000000
r = Random.new
values = Array(String).new(size) { |i| r.rand(size).to_s }

arr = Stack.new
list = StackLinkedList.new

Benchmark.ips do |x|
  x.report("array") { values.each {|i| arr.push(i) } }
  x.report("list") { values.each {|i| list.push(i) } }
end

# crystal stack/bench.cr --release
# array 251.01  (  3.98ms) (±15.44%)       fastest
#  list  20.28  ( 49.31ms) (±62.87%) 12.38× slower