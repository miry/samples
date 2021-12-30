# https://adventofcode.com/2021/day/22
#
# --- Day 22: ... ---
#

def problem22(records : Array(String))
  reactor = Set(Tuple(Int32, Int32, Int32)).new
  records.each do |line|
    next if line.empty?

    action, ranges = line.split(" ", 2)
    ignore = false
    x_range, y_range, z_range = ranges.split(",", 3).map do |r|
      edges = r[2..].split("..", 2).map(&.to_i32)
      ignore = !(-50..50).includes?(edges[0]) || !(-50..50).includes?(edges[1]) if !ignore
      Range.new(edges[0], edges[1])
    end
    next if ignore

    if action == "on"
      x_range.each do |x|
        y_range.each do |y|
          z_range.each do |z|
            reactor.add({x, y, z})
          end
        end
      end
    else
      x_range.each do |x|
        y_range.each do |y|
          z_range.each do |z|
            reactor.delete({x, y, z})
          end
        end
      end
    end
    puts "#{reactor.size} -- line: #{line}"
  end

  return reactor.size
end

def concat_ranges(r1, r2)
  result = Array(Range(Int32, Int32)).new
  if !r1.includes?(r2.begin) && !r1.includes?(r2.end) && !r2.includes?(r1.begin) && !r2.includes?(r1.end)
    result = [r1, r2]
  elsif r1.includes?(r2.begin) && r1.includes?(r2.end)
    result = [r1]
  elsif r2.includes?(r1.begin) && r2.includes?(r1.end)
    result = [r2]
  elsif r1.includes?(r2.begin)
    result = [Range.new(r1.begin, r2.end)]
  elsif r1.includes?(r2.end)
    result = [Range.new(r2.begin, r1.end)]
  elsif r2.includes?(r1.begin)
    result = [Range.new(r2.begin, r1.end)]
  elsif r2.includes?(r1.end)
    result = [Range.new(r1.begin, r2.end)]
  else
    raise "not implemented"
  end

  return result
end

def subtract_ranges(r1, r2)
  result = Array(Range(Int32, Int32)).new
  if !r1.includes?(r2.begin) && !r1.includes?(r2.end) && !r2.includes?(r1.begin) && !r2.includes?(r1.end)
    result = [r1]
  elsif r1.includes?(r2.begin) && r1.includes?(r2.end)
    result << Range.new(r1.begin, r2.begin - 1) if r1.begin != r2.begin
    result << Range.new(r2.end + 1, r1.end) if r1.end != r2.end
  elsif r2.includes?(r1.begin) && r2.includes?(r1.end)
  elsif r1.includes?(r2.begin)
    result << Range.new(r1.begin, r2.begin - 1) if r1.begin != r2.begin
  elsif r1.includes?(r2.end)
    result << Range.new(r2.end + 1, r1.end) if r1.end != r2.end
  else
    raise "not implemented !!! #{r1} #{r2}"
  end

  return result
end

def common_range(r1, r2) : Range(Int32, Int32)?
  if !r1.includes?(r2.begin) && !r1.includes?(r2.end) &&
     !r2.includes?(r1.begin) && !r2.includes?(r1.end)
    return nil
  end

  if r1.includes?(r2.begin) && r1.includes?(r2.end)
    return r2
  end

  if r2.includes?(r1.begin) && r2.includes?(r1.end)
    return r1
  end

  if r1.includes?(r2.begin)
    return Range.new(r2.begin, r1.end)
  end

  if r1.includes?(r2.end)
    return Range.new(r1.begin, r2.end)
  end

  return nil
end

def merge_ranges(ranges)
  return ranges if ranges.empty?
  rs = ranges.sort { |a, b| a.begin <=> b.begin }
  result = [rs.first]
  rs.each do |r|
    a = result.pop
    result += concat_ranges(a, r)
  end
  return result
end

def subtrack_massive_ranges(ranges, r2)
  return ranges if ranges.empty?
  rs = ranges.sort { |a, b| a.begin <=> b.begin }
  result = [] of Range(Int32, Int32)
  rs.each do |r|
    result += subtract_ranges(r, r2)
  end
  return result
end

def problem22_part_two(records : Array(String), initial = false)
  activites = Array(Tuple(Bool, Range(Int32, Int32), Range(Int32, Int32), Range(Int32, Int32))).new

  reactor = Set(Tuple(Int32, Int32, Int32)).new
  counter = 0_i64
  x_ranges = Array(Range(Int32, Int32)).new
  y_ranges = Array(Range(Int32, Int32)).new
  z_ranges = Array(Range(Int32, Int32)).new

  records.each do |line|
    next if line.empty?

    # puts "\n-- line: #{line}"

    action, ranges = line.split(" ", 2)
    ignore = false
    x_range, y_range, z_range = ranges.split(",", 3).map do |r|
      edges = r[2..].split("..", 2).map(&.to_i32)
      ignore = !(-50..50).includes?(edges[0]) || !(-50..50).includes?(edges[1]) if !ignore
      Range.new(edges[0], edges[1])
    end
    next if initial && ignore

    activity = {action == "on", x_range, y_range, z_range}
    activites << activity

    x_diff = 0
    x_ranges.each do |r1|
      r = common_range(r1, x_range)
      x_diff += r.size if r
      puts "common x: #{r}  -> #{x_diff}"
    end
    y_diff = 0
    y_ranges.each do |r1|
      r = common_range(r1, y_range)
      y_diff += r.size if r
      puts "common y: #{r}  -> #{y_diff}"
    end
    z_diff = 0
    z_ranges.each do |r1|
      r = common_range(r1, z_range)
      z_diff += r.size if r
      puts "common z: #{r}  -> #{z_diff}"
    end
    puts "  x_ranges: "
    p x_ranges

    puts "  x_range: "
    p x_range

    if action == "on"
      x_ranges << x_range
      y_ranges << y_range
      z_ranges << z_range

      step = (1_i64 * x_range.size * y_range.size * z_range.size) - (1_i64 * x_diff * y_diff * z_diff)
      puts " step: #{step}"
      counter += step
    else
      x_ranges = subtrack_massive_ranges(x_ranges, x_range)
      y_ranges = subtrack_massive_ranges(y_ranges, y_range)
      z_ranges = subtrack_massive_ranges(z_ranges, z_range)
      counter -= 1_i64 * x_diff * y_diff * z_diff
    end

    x_ranges = merge_ranges(x_ranges)
    y_ranges = merge_ranges(y_ranges)
    z_ranges = merge_ranges(z_ranges)

    puts "  after ranges: "
    p [x_ranges, y_ranges, z_ranges]

    puts "#{counter} -- line: #{line}"
  end
  return counter
end
