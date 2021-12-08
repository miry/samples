# https://adventofcode.com/2021/day/7
#
# --- Day 7: ... ---
#

def problem7(records : String)
  positions = records.split(",").map(&.to_i64)

  min = positions[0]
  max = positions[0]

  crabs = Hash(Int64, Int64).new(0)
  positions.each do |p|
    crabs[p] += 1
    if min > p
      min = p
    end

    if max < p
      max = p
    end
  end

  # puts "Init>"
  # puts max, min
  #
  # sums = Hash(Int64, Int64).new(0)
  min_sum = -1_i64
  min.upto(max) do |height|
    # puts "Height: #{height}"
    s = 0.to_i64
    crabs.each do |position, counter|
      s += (height - position).abs * counter
    end
    min_sum = s if min_sum == -1 || min_sum > s
  end

  return min_sum
end

# --- Part Two ---

def problem7_part_two(records : String)
  positions = records.split(",").map(&.to_i64)

  min = positions[0]
  max = positions[0]

  crabs = Hash(Int64, Int64).new(0)
  positions.each do |p|
    crabs[p] += 1
    if min > p
      min = p
    end

    if max < p
      max = p
    end
  end

  # puts "Init>"
  # puts max, min
  #
  # sums = Hash(Int64, Int64).new(0)
  min_sum = -1_i64
  min.upto(max) do |height|
    # puts "Height: #{height}"
    s = 0.to_i64
    crabs.each do |position, counter|
      s += fuel(height, position) * counter
    end
    min_sum = s if min_sum == -1 || min_sum > s
  end

  return min_sum
end

def fuel(n : Int64, m : Int64) : Int64
  i = (m - n).abs
  r = (1 + i) / 2 * i
  r.to_i64
end
