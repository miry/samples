# https://adventofcode.com/2021/day/13
#
# --- Day 13: Transparent Origami ---
# 
# You reach another volcanically active part of the cave. It would be nice if you could do some kind of thermal imaging so you could tell ahead of time which caves are too hot to safely enter.
# 
# Fortunately, the submarine seems to be equipped with a thermal camera! When you activate it, you are greeted with:
# 
# Congratulations on your purchase! To activate this infrared thermal imaging
# camera system, please enter the code found on page 1 of the manual.
# 
# Apparently, the Elves have never used this feature. To your surprise, you manage to find the manual; as you go to open it, page 1 falls out. It's a large sheet of transparent paper! The transparent paper is marked with random dots and includes instructions on how to fold it up (your puzzle input). For example:
# 
# 6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0
# 
# fold along y=7
# fold along x=5
# 
# The first section is a list of dots on the transparent paper. 0,0 represents the top-left coordinate. The first value, x, increases to the right. The second value, y, increases downward. So, the coordinate 3,0 is to the right of 0,0, and the coordinate 0,7 is below 0,0. The coordinates in this example form the following pattern, where # is a dot on the paper and . is an empty, unmarked position:
# 
# ...#..#..#.
# ....#......
# ...........
# #..........
# ...#....#.#
# ...........
# ...........
# ...........
# ...........
# ...........
# .#....#.##.
# ....#......
# ......#...#
# #..........
# #.#........
# 
# Then, there is a list of fold instructions. Each instruction indicates a line on the transparent paper and wants you to fold the paper up (for horizontal y=... lines) or left (for vertical x=... lines). In this example, the first fold instruction is fold along y=7, which designates the line formed by all of the positions where y is 7 (marked here with -):
# 
# ...#..#..#.
# ....#......
# ...........
# #..........
# ...#....#.#
# ...........
# ...........
# -----------
# ...........
# ...........
# .#....#.##.
# ....#......
# ......#...#
# #..........
# #.#........
# 
# Because this is a horizontal line, fold the bottom half up. Some of the dots might end up overlapping after the fold is complete, but dots will never appear exactly on a fold line. The result of doing this fold looks like this:
# 
# #.##..#..#.
# #...#......
# ......#...#
# #...#......
# .#.#..#.###
# ...........
# ...........
# 
# Now, only 17 dots are visible.
# 
# Notice, for example, the two dots in the bottom left corner before the transparent paper is folded; after the fold is complete, those dots appear in the top left corner (at 0,0 and 0,1). Because the paper is transparent, the dot just below them in the result (at 0,3) remains visible, as it can be seen through the transparent paper.
# 
# Also notice that some dots can end up overlapping; in this case, the dots merge together and become a single dot.
# 
# The second fold instruction is fold along x=5, which indicates this line:
# 
# #.##.|#..#.
# #...#|.....
# .....|#...#
# #...#|.....
# .#.#.|#.###
# .....|.....
# .....|.....
# 
# Because this is a vertical line, fold left:
# 
# #####
# #...#
# #...#
# #...#
# #####
# .....
# .....
# 
# The instructions made a square!
# 
# The transparent paper is pretty big, so for now, focus on just completing the first fold. After the first fold in the example above, 17 dots are visible - dots that end up overlapping after the fold is completed count as a single dot.
# 
# How many dots are visible after completing just the first fold instruction on your transparent paper?
# 
# Your puzzle answer was 818.
# --- Part Two ---
# 
# Finish folding the transparent paper according to the instructions. The manual says the code is always eight capital letters.
# 
# What code do you use to activate the infrared thermal imaging camera system?
# 
# Your puzzle answer was LRGPRECB.

def problem13(input : Array(String))
  dots = Hash(Tuple(Int32, Int32), Bool).new
  i = 0
  input.each do |line|
    i += 1
    break if line.empty?
    coord_raw = line.split(",", 2).map(&.to_i32)
    dots[{coord_raw[0], coord_raw[1]}] = true
  end

  foldes = Array(Tuple(String, Int32)).new
  input[i..-1].each do |line|
    break if line.empty?
    raw = line[11..-1].split("=")
    foldes << {raw[0], raw[1].to_i32}
  end

  foldes.each do |fold|
    new_dots = Hash(Tuple(Int32, Int32), Bool).new
    dots.each do |old_coord, val|
      coord = [old_coord[0], old_coord[1]]
      fold_line_orientation = fold[0] == "x" ? 0 : 1
      if coord[fold_line_orientation] >= fold[1]
        diff = coord[fold_line_orientation] - fold[1]
        coord[fold_line_orientation] = fold[1] - diff
      end
      c = {coord[0], coord[1]}
      new_dots[c] = true
    end
    dots = new_dots
    break
  end

  return dots.size
end

def print_dots(dots, output = STDOUT)
  max_x = 0
  max_y = 0
  dots.each do |coord, v|
    max_x = coord[0] if coord[0] > max_x
    max_y = coord[1] if coord[1] > max_y
  end

  result = Array(String).new
  (max_y + 1).times do |row|
    line = [] of String
    (max_x + 1).times do |col|
      coord = {col, row}
      line << (dots.has_key?(coord) ? "#" : ".")
    end
    result << line.join
  end

  output.puts result.join("\n")

  return result
end

def problem13_part_two(input : Array(String), output = STDOUT)
  dots = Hash(Tuple(Int32, Int32), Bool).new
  i = 0
  input.each do |line|
    i += 1
    break if line.empty?
    coord_raw = line.split(",", 2).map(&.to_i32)
    dots[{coord_raw[0], coord_raw[1]}] = true
  end

  foldes = Array(Tuple(String, Int32)).new
  input[i..-1].each do |line|
    break if line.empty?
    raw = line[11..-1].split("=")
    foldes << {raw[0], raw[1].to_i32}
  end

  foldes.each do |fold|
    new_dots = Hash(Tuple(Int32, Int32), Bool).new
    dots.each do |old_coord, val|
      coord = [old_coord[0], old_coord[1]]
      fold_line_orientation = fold[0] == "x" ? 0 : 1
      if coord[fold_line_orientation] >= fold[1]
        diff = coord[fold_line_orientation] - fold[1]
        coord[fold_line_orientation] = fold[1] - diff
      end
      c = {coord[0], coord[1]}
      new_dots[c] = true
    end
    dots = new_dots
  end

  print_dots(dots, output)

  return dots
end
