# https://adventofcode.com/2021/day/9
#
# --- Day 9: Smoke Basin ---
#
# These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.
#
# If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).
#
# Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.
#
# Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)
#
# In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.
#
# The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.
#
# Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?
#
# Your puzzle answer was 530.

def problem9(records : Array(String))
  records.reject! { |r| r == "" }
  numbers = records.map { |row| row.chars.map(&.to_i64) }

  n = numbers.size
  m = numbers[0].size

  lowers = [] of Int64
  n.times do |r|
    m.times do |c|
      cell = numbers[r][c]
      found = true
      [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}].each do |coord|
        if coord[0] >= 0 && coord[1] >= 0 && coord[0] < n && coord[1] < m
          if cell >= numbers[coord[0]][coord[1]]
            found = false
            break
          end
        end
      end

      lowers << cell if found
    end
  end

  return lowers.map { |i| i + 1 }.reduce(0) { |acc, i| acc + i }
end

# --- Part Two ---
#
# Next, you need to find the largest basins so you know what areas are most important to avoid.
#
# A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.
#
# The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.
#
# The top-left basin, size 3:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# The top-right basin, size 9:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# The middle basin, size 14:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# The bottom-right basin, size 9:
#
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
#
# Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.
#
# What do you get if you multiply together the sizes of the three largest basins?
#
# Your puzzle answer was 1019494.

def problem9_part_two(records : Array(String))
  records.reject! { |r| r == "" }
  numbers = records.map { |row| row.chars.map(&.to_i64) }

  n = numbers.size
  m = numbers[0].size

  lowers = [] of Tuple(Int32, Int32)
  n.times do |r|
    m.times do |c|
      cell = numbers[r][c]
      found = true

      [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}].each do |coord|
        if coord[0] >= 0 && coord[1] >= 0 && coord[0] < n && coord[1] < m
          if cell >= numbers[coord[0]][coord[1]]
            found = false
            break
          end
        end
      end

      lowers << {r, c} if found
    end
  end

  basins = [] of Int32
  lowers.each do |low_point|
    queue = Set(Tuple(Int32, Int32)).new
    queue.add low_point

    while true
      new_queue = queue.dup
      queue.each do |current_point|
        r = current_point[0]
        c = current_point[1]
        [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}].each do |coord|
          if coord[0] >= 0 && coord[1] >= 0 && coord[0] < n && coord[1] < m
            new_queue.add(coord) if numbers[coord[0]][coord[1]] != 9
          end
        end
      end
      break if queue.size == new_queue.size
      queue = new_queue
    end
    basins << queue.size
  end

  return basins.sort[-3..-1].reduce(1_i64) { |acc, i| acc * i }
end
