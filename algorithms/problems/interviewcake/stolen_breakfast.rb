# frozen_string_literal: false

def stolen_breakfast(list)
  result = 0
  list.each do |item|
    puts "item: #{item} /  #{item.to_s(2)}"
    puts "result: #{result.to_s(2)}"
    result ^= item
    puts "xor: #{result.to_s(2)}"
  end
  return result
end
