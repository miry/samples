# https://adventofcode.com/2021/day/5
#
# --- Day 5: Hydrothermal Venture ---
#
# You come across a field of hydrothermal vents on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.
#
# They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:
#
# 0,9 -> 5,9
# 8,0 -> 0,8
# 9,4 -> 3,4
# 2,2 -> 2,1
# 7,0 -> 7,4
# 6,4 -> 2,0
# 0,9 -> 2,9
# 3,4 -> 1,4
# 0,0 -> 8,8
# 5,5 -> 8,2
#
# Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the coordinates of one end the line segment and x2,y2 are the coordinates of the other end. These line segments include the points at both ends. In other words:
#
#     An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
#     An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.
#
# For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.
#
# So, the horizontal and vertical lines from the above list would produce the following diagram:
#
# .......1..
# ..1....1..
# ..1....1..
# .......1..
# .112111211
# ..........
# ..........
# ..........
# ..........
# 222111....
#
# In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9. Each position is shown as the number of lines which cover that point or . if no line covers that point. The top-left pair of 1s, for example, comes from 2,2 -> 2,1; the very bottom row is formed by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.
#
# To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.
#
# Consider only horizontal and vertical lines. At how many points do at least two lines overlap?
#
# Your puzzle answer was 5197.

struct Coord
  property x : Int32
  property y : Int32

  def initialize(@x, @y)
  end
end

def problem5(records : Array(String))
  xlines = [] of Tuple(Coord, Coord)
  ylines = [] of Tuple(Coord, Coord)

  max_x = 0
  max_y = 0

  records.each do |line_raw|
    next if line_raw == ""
    start_raw, end_raw = line_raw.split(" -> ", 2)
    start_coord = Coord.new *start_raw.split(",", 2).map(&.to_i32).values_at(0, 1)
    end_coord = Coord.new *end_raw.split(",", 2).map(&.to_i32).values_at(0, 1)

    if start_coord.x == end_coord.x
      if max_x < end_coord.x
        max_x = end_coord.x
      end

      if start_coord.y > end_coord.y
        t = start_coord
        start_coord = end_coord
        end_coord = t
      end

      if max_y < end_coord.y
        max_y = end_coord.y
      end

      xlines << {start_coord, end_coord}
    elsif start_coord.y == end_coord.y
      if max_y < end_coord.y
        max_y = end_coord.y
      end

      if start_coord.x > end_coord.x
        t = start_coord
        start_coord = end_coord
        end_coord = t
      end

      if max_x < end_coord.x
        max_x = end_coord.x
      end

      ylines << {start_coord, end_coord}
    end
  end

  board = Array(Array(Int32)).new
  (max_x + 1).times do |i|
    board << Array.new(max_y + 1, 0)
  end

  xlines.each do |line|
    line[0].y.upto(line[1].y) do |y|
      board[line[0].x][y] += 1
    end
  end

  ylines.each do |line|
    line[0].x.upto(line[1].x) do |x|
      board[x][line[0].y] += 1
    end
  end

  result = 0
  board.each do |row|
    row.each do |cell|
      result += 1 if cell >= 2
    end
  end

  return result
end

# --- Part Two ---
#
# Unfortunately, considering only horizontal and vertical lines doesn't give you the full picture; you need to also consider diagonal lines.
#
# Because of the limits of the hydrothermal vent mapping system, the lines in your list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees. In other words:
#
#     An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
#     An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.
#
# Considering all lines from the above example would now produce the following diagram:
#
# 1.1....11.
# .111...2..
# ..2.1.111.
# ...1.2.2..
# .112313211
# ...1.2....
# ..1...1...
# .1.....1..
# 1.......1.
# 222111....
#
# You still need to determine the number of points where at least two lines overlap. In the above example, this is still anywhere in the diagram with a 2 or larger - now a total of 12 points.
#
# Consider all of the lines. At how many points do at least two lines overlap?
#
# Your puzzle answer was 18605.

def problem5_part_two(records : Array(String))
  xlines = [] of Tuple(Coord, Coord)
  ylines = [] of Tuple(Coord, Coord)
  dlines = [] of Tuple(Coord, Coord)

  max_x = 0
  max_y = 0

  records.each do |line_raw|
    next if line_raw == ""
    start_raw, end_raw = line_raw.split(" -> ", 2)
    start_coord = Coord.new *start_raw.split(",", 2).map(&.to_i32).values_at(0, 1)
    end_coord = Coord.new *end_raw.split(",", 2).map(&.to_i32).values_at(0, 1)

    if start_coord.x == end_coord.x
      if max_x < end_coord.x
        max_x = end_coord.x
      end

      if start_coord.y > end_coord.y
        t = start_coord
        start_coord = end_coord
        end_coord = t
      end

      if max_y < end_coord.y
        max_y = end_coord.y
      end

      xlines << {start_coord, end_coord}
    elsif start_coord.y == end_coord.y
      if max_y < end_coord.y
        max_y = end_coord.y
      end

      if start_coord.x > end_coord.x
        t = start_coord
        start_coord = end_coord
        end_coord = t
      end

      if max_x < end_coord.x
        max_x = end_coord.x
      end

      ylines << {start_coord, end_coord}
    elsif (start_coord.x - end_coord.x).abs == (start_coord.y - end_coord.y).abs
      if max_y < end_coord.y
        max_y = end_coord.y
      end

      if start_coord.x > end_coord.x
        t = start_coord
        start_coord = end_coord
        end_coord = t
      end

      if max_x < end_coord.x
        max_x = end_coord.x
      end

      dlines << {start_coord, end_coord}
    end
  end

  board = Array(Array(Int32)).new
  (max_x + 1).times do |i|
    board << Array.new(max_y + 1, 0)
  end

  xlines.each do |line|
    line[0].y.upto(line[1].y) do |y|
      board[line[0].x][y] += 1
    end
  end

  ylines.each do |line|
    line[0].x.upto(line[1].x) do |x|
      board[x][line[0].y] += 1
    end
  end

  dlines.each do |line|
    dx = (line[0].x - line[1].x) > 0 ? 1 : -1
    dy = (line[0].y - line[1].y) > 0 ? 1 : -1

    x = line[1].x
    y = line[1].y
    n = (line[0].x - line[1].x).abs + 1
    n.times do |i|
      board[x + i*dx][y + i*dy] += 1
    end
  end

  result = 0
  board.each do |row|
    row.each do |cell|
      result += 1 if cell >= 2
    end
  end

  return result
end
