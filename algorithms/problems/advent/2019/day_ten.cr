# https://adventofcode.com/2019/day/10
#
# --- Day 10: Monitoring Station ---
#
# You fly into the asteroid belt and reach the Ceres monitoring station. The Elves here have an emergency: they're having trouble tracking all of the asteroids and can't be sure they're safe.
#
# The Elves would like to build a new monitoring station in a nearby area of space; they hand you a map of all of the asteroids in that region (your puzzle input).
#
# The map indicates whether each position is empty (.) or contains an asteroid (#). The asteroids are much smaller than they appear on the map, and every asteroid is exactly in the center of its marked position. The asteroids can be described with X,Y coordinates where X is the distance from the left edge and Y is the distance from the top edge (so the top-left corner is 0,0 and the position immediately to its right is 1,0).
#
# Your job is to figure out which asteroid would be the best place to build a new monitoring station. A monitoring station can detect any asteroid to which it has direct line of sight - that is, there cannot be another asteroid exactly between them. This line of sight can be at any angle, not just lines aligned to the grid or diagonally. The best location is the asteroid that can detect the largest number of other asteroids.
#
# For example, consider the following map:
#
# .#..#
# .....
# #####
# ....#
# ...##
#
# The best location for a new monitoring station on this map is the highlighted asteroid at 3,4 because it can detect 8 asteroids, more than any other location. (The only asteroid it cannot detect is the one at 1,0; its view of this asteroid is blocked by the asteroid at 2,2.) All other asteroids are worse locations; they can detect 7 or fewer other asteroids. Here is the number of other asteroids a monitoring station on each asteroid could detect:
#
# .7..7
# .....
# 67775
# ....7
# ...87
#
# Here is an asteroid (#) and some examples of the ways its line of sight might be blocked. If there were another asteroid at the location of a capital letter, the locations marked with the corresponding lowercase letter would be blocked and could not be detected:
#
# #.........
# ...A......
# ...B..a...
# .EDCG....a
# ..F.c.b...
# .....c....
# ..efd.c.gb
# .......c..
# ....f...c.
# ...e..d..c
#
# Here are some larger examples:
#
#     Best is 5,8 with 33 other asteroids detected:
#
#     ......#.#.
#     #..#.#....
#     ..#######.
#     .#.#.###..
#     .#..#.....
#     ..#....#.#
#     #..#....#.
#     .##.#..###
#     ##...#..#.
#     .#....####
#
#     Best is 1,2 with 35 other asteroids detected:
#
#     #.#...#.#.
#     .###....#.
#     .#....#...
#     ##.#.#.#.#
#     ....#.#.#.
#     .##..###.#
#     ..#...##..
#     ..##....##
#     ......#...
#     .####.###.
#
#     Best is 6,3 with 41 other asteroids detected:
#
#     .#..#..###
#     ####.###.#
#     ....###.#.
#     ..###.##.#
#     ##.##.#.#.
#     ....###..#
#     ..#.#..#.#
#     #..#.#.###
#     .##...##.#
#     .....#.#..
#
#     Best is 11,13 with 210 other asteroids detected:
#
#     .#..##.###...#######
#     ##.############..##.
#     .#.######.########.#
#     .###.#######.####.#.
#     #####.##.#.##.###.##
#     ..#####..#.#########
#     ####################
#     #.####....###.#.#.##
#     ##.#################
#     #####.##.###..####..
#     ..######..##.#######
#     ####.##.####...##..#
#     .#####..#.######.###
#     ##...#.##########...
#     #.##########.#######
#     .####.#.###.###.#.##
#     ....##.##.###..#####
#     .#.#.###########.###
#     #.#.#.#####.####.###
#     ###.##.####.##.#..##
#
# Find the best location for a new monitoring station. How many other asteroids can be detected from that location?
#
# --- Part Two ---
#
# Once you give them the coordinates, the Elves quickly deploy an Instant Monitoring Station to the location and discover the worst: there are simply too many asteroids.
#
# The only solution is complete vaporization by giant laser.
#
# Fortunately, in addition to an asteroid scanner, the new monitoring station also comes equipped with a giant rotating laser perfect for vaporizing asteroids. The laser starts by pointing up and always rotates clockwise, vaporizing any asteroid it hits.
#
# If multiple asteroids are exactly in line with the station, the laser only has enough power to vaporize one of them before continuing its rotation. In other words, the same asteroids that can be detected can be vaporized, but if vaporizing one asteroid makes another one detectable, the newly-detected asteroid won't be vaporized until the laser has returned to the same position by rotating a full 360 degrees.
#
# For example, consider the following map, where the asteroid with the new monitoring station (and laser) is marked X:
#
# .#....#####...#..
# ##...##.#####..##
# ##...#...#.#####.
# ..#.....X...###..
# ..#.#.....#....##
#
# The first nine asteroids to get vaporized, in order, would be:
#
# .#....###24...#..
# ##...##.13#67..9#
# ##...#...5.8####.
# ..#.....X...###..
# ..#.#.....#....##
#
# Note that some asteroids (the ones behind the asteroids marked 1, 5, and 7) won't have a chance to be vaporized until the next full rotation. The laser continues rotating; the next nine to be vaporized are:
#
# .#....###.....#..
# ##...##...#.....#
# ##...#......1234.
# ..#.....X...5##..
# ..#.9.....8....76
#
# The next nine to be vaporized are then:
#
# .8....###.....#..
# 56...9#...#.....#
# 34...7...........
# ..2.....X....##..
# ..1..............
#
# Finally, the laser completes its first full rotation (1 through 3), a second rotation (4 through 8), and vaporizes the last asteroid (9) partway through its third rotation:
#
# ......234.....6..
# ......1...5.....7
# .................
# ........X....89..
# .................
#
# In the large example above (the one with the best monitoring station location at 11,13):
#
#     The 1st asteroid to be vaporized is at 11,12.
#     The 2nd asteroid to be vaporized is at 12,1.
#     The 3rd asteroid to be vaporized is at 12,2.
#     The 10th asteroid to be vaporized is at 12,8.
#     The 20th asteroid to be vaporized is at 16,0.
#     The 50th asteroid to be vaporized is at 16,9.
#     The 100th asteroid to be vaporized is at 10,16.
#     The 199th asteroid to be vaporized is at 9,6.
#     The 200th asteroid to be vaporized is at 8,2.
#     The 201st asteroid to be vaporized is at 10,9.
#     The 299th and final asteroid to be vaporized is at 11,1.
#
# The Elves are placing bets on which will be the 200th asteroid to be vaporized. Win the bet by determining which asteroid that will be; what do you get if you multiply its X coordinate by 100 and then add its Y coordinate? (For example, 8,2 becomes 802.)

class AsteroidMap
  EMPTY_CELL    = '.'
  ASTEROID_CELL = '#'

  def initialize(@map : Array(String))
    @asteroids = [] of Tuple(Int32, Int32)
    @station_coord = {0, 0}
  end

  def size
    x = @map.size
    y = @map[0].size
    {x, y}
  end

  def suggestion
    cells = asteroids
    max = {0, cells[0]}
    cells.each do |cell0|
      cs = assteroids_coeficients_around(cell0)
      counts = cs.size
      if counts > max[0]
        max = {counts, cell0}
      end
    end
    @station_coord = max[1]
    return max
  end

  def vaporized_in(counter : Int)
    suggestion

    coords = assteroids_coeficients_around @station_coord

    coords_order = coords.keys.sort do |a, b|
      a[0] <=> b[0]
    end

    buckets = {} of Float64 => Hash(Float64, Array(Tuple(Float64, Float64, Float64)))

    coords_order.each do |coord|
      unless buckets.has_key?(coord[1])
        buckets[coord[1]] = {0 => [] of Tuple(Float64, Float64, Float64), 1 => [] of Tuple(Float64, Float64, Float64), -1 => [] of Tuple(Float64, Float64, Float64)} of Float64 => Array(Tuple(Float64, Float64, Float64))
      end

      buckets[coord[1]][coord[2]] << coord
    end

    coords_order = [] of Tuple(Float64, Float64, Float64)
    coords_order += buckets[-1][0]
    coords_order += buckets[-1][1]
    coords_order += buckets[0][1]
    coords_order += buckets[1][1]
    coords_order += buckets[1][0]
    coords_order += buckets[1][-1]
    coords_order += buckets[0][-1]
    coords_order += buckets[-1][-1]

    result = @station_coord
    n = coords_order.size
    counter.times do |i|
      key = coords_order[i % n]
      while coords[key].size == 0
        coords_order.delete_at(i % n)
        n -= 1
        key = coords_order[i % n]
      end
      result = coords[key].delete_at(0)
    end
    result
  end

  def assteroids_coeficients_around(cell0)
    cells = asteroids
    dict = {} of Tuple(Float64, Float64, Float64) => Array(Tuple(Int32, Int32))
    cells.each do |cell1|
      next if cell0 == cell1
      c = coefficient(cell0, cell1)
      if dict.has_key?(c)
        dict[c] << cell1
      else
        dict[c] = [cell1] of Tuple(Int32, Int32)
      end

      dict[c].sort! do |a, b|
        distance(cell0, a) <=> distance(cell0, b)
      end
    end
    # puts "----"
    # puts "cell: #{cell0}"
    # puts "cells:     #{cells - [cell0]}"
    # puts "coef:      #{result}"
    # puts "coef uniq: #{result.uniq}"
    # puts "counts: #{counts}"
    # puts "dict[#{dict.size}]:       #{dict}"
    # puts "dict no uniq:"
    # dict.each do |k, v|
    #   puts "#{k}  => #{v}"
    # end
    dict
  end

  def coefficient(cell0, cell1)
    x0, y0 = cell0
    x1, y1 = cell1

    dy = y1 - y0
    dx = x1 - x0

    k = dx == 0 ? 999.0 : dy / dx
    b = dy > 0 ? 1_f64 : dy < 0 ? -1_f64 : 0_f64
    d = dx > 0 ? 1_f64 : dx < 0 ? -1_f64 : 0_f64

    if k == 999.0 && b == -1
      k = -999.0
    end

    {k, b, d}
  end

  def asteroids
    return @asteroids if @asteroids.size > 0
    @map.each_with_index do |row, x|
      row.each_char_with_index do |cell, y|
        next if cell == EMPTY_CELL
        @asteroids << {y, x}
      end
    end
    @asteroids
  end

  def distance(cell0, cell1)
    x0, y0 = cell0
    x1, y1 = cell1

    dy = y1 - y0
    dx = x1 - x0

    dx.abs + dy.abs
  end
end
