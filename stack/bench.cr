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
# array  25.79k ( 38.78µs) (±16.47%)       fastest
#  list 798.61  (  1.25ms) (± 4.80%) 32.29× slower