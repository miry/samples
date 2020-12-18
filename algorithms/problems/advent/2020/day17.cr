# https://adventofcode.com/2020/day/17

# --- Day 17: Conway Cubes ---

# As your flight slowly drifts through the sky, the Elves at the Mythical Information Bureau at the North Pole contact you. They'd like some help debugging a malfunctioning experimental energy source aboard one of their super-secret imaging satellites.

# The experimental energy source is based on cutting-edge technology: a set of Conway Cubes contained in a pocket dimension! When you hear it's having problems, you can't help but agree to take a look.

# The pocket dimension contains an infinite 3-dimensional grid. At every integer 3-dimensional coordinate (x,y,z), there exists a single cube which is either active or inactive.

# In the initial state of the pocket dimension, almost all cubes start inactive. The only exception to this is a small flat region of cubes (your puzzle input); the cubes in this region start in the specified active (#) or inactive (.) state.

# The energy source then proceeds to boot up by executing six cycles.

# Each cube only ever considers its neighbors: any of the 26 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3, its neighbors include the cube at x=2,y=2,z=2, the cube at x=0,y=2,z=3, and so on.

# During a cycle, all cubes simultaneously change their state according to the following rules:

#     If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
#     If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.

# The engineers responsible for this experimental energy source would like you to simulate the pocket dimension and determine what the configuration of cubes should be at the end of the six-cycle boot process.

# For example, consider the following initial state:

# .#.
# ..#
# ###

# Even though the pocket dimension is 3-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1 region of the 3-dimensional space.)

# Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z coordinate (and the frame of view follows the active cells in each cycle):

# Before any cycles:

# z=0
# .#.
# ..#
# ###

# After 1 cycle:

# z=-1
# #..
# ..#
# .#.

# z=0
# #.#
# .##
# .#.

# z=1
# #..
# ..#
# .#.

# After 2 cycles:

# z=-2
# .....
# .....
# ..#..
# .....
# .....

# z=-1
# ..#..
# .#..#
# ....#
# .#...
# .....

# z=0
# ##...
# ##...
# #....
# ....#
# .###.

# z=1
# ..#..
# .#..#
# ....#
# .#...
# .....

# z=2
# .....
# .....
# ..#..
# .....
# .....

# After 3 cycles:

# z=-2
# .......
# .......
# ..##...
# ..###..
# .......
# .......
# .......

# z=-1
# ..#....
# ...#...
# #......
# .....##
# .#...#.
# ..#.#..
# ...#...

# z=0
# ...#...
# .......
# #......
# .......
# .....##
# .##.#..
# ...#...

# z=1
# ..#....
# ...#...
# #......
# .....##
# .#...#.
# ..#.#..
# ...#...

# z=2
# .......
# .......
# ..##...
# ..###..
# .......
# .......
# .......

# After the full six-cycle boot process completes, 112 cubes are left in the active state.

# Starting with your given initial configuration, simulate six cycles. How many cubes are left in the active state after the sixth cycle?

# Your puzzle answer was 232.
# --- Part Two ---

# For some reason, your simulated results don't match what the experimental energy source engineers expected. Apparently, the pocket dimension actually has four spatial dimensions, not three.

# The pocket dimension contains an infinite 4-dimensional grid. At every integer 4-dimensional coordinate (x,y,z,w), there exists a single cube (really, a hypercube) which is still either active or inactive.

# Each cube only ever considers its neighbors: any of the 80 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3,w=4, its neighbors include the cube at x=2,y=2,z=3,w=3, the cube at x=0,y=2,z=3,w=4, and so on.

# The initial state of the pocket dimension still consists of a small flat region of cubes. Furthermore, the same rules for cycle updating still apply: during each cycle, consider the number of active neighbors of each cube.

# For example, consider the same initial state as in the example above. Even though the pocket dimension is 4-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1x1 region of the 4-dimensional space.)

# Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z and w coordinate:

# Before any cycles:

# z=0, w=0
# .#.
# ..#
# ###

# After 1 cycle:

# z=-1, w=-1
# #..
# ..#
# .#.

# z=0, w=-1
# #..
# ..#
# .#.

# z=1, w=-1
# #..
# ..#
# .#.

# z=-1, w=0
# #..
# ..#
# .#.

# z=0, w=0
# #.#
# .##
# .#.

# z=1, w=0
# #..
# ..#
# .#.

# z=-1, w=1
# #..
# ..#
# .#.

# z=0, w=1
# #..
# ..#
# .#.

# z=1, w=1
# #..
# ..#
# .#.

# After 2 cycles:

# z=-2, w=-2
# .....
# .....
# ..#..
# .....
# .....

# z=-1, w=-2
# .....
# .....
# .....
# .....
# .....

# z=0, w=-2
# ###..
# ##.##
# #...#
# .#..#
# .###.

# z=1, w=-2
# .....
# .....
# .....
# .....
# .....

# z=2, w=-2
# .....
# .....
# ..#..
# .....
# .....

# z=-2, w=-1
# .....
# .....
# .....
# .....
# .....

# z=-1, w=-1
# .....
# .....
# .....
# .....
# .....

# z=0, w=-1
# .....
# .....
# .....
# .....
# .....

# z=1, w=-1
# .....
# .....
# .....
# .....
# .....

# z=2, w=-1
# .....
# .....
# .....
# .....
# .....

# z=-2, w=0
# ###..
# ##.##
# #...#
# .#..#
# .###.

# z=-1, w=0
# .....
# .....
# .....
# .....
# .....

# z=0, w=0
# .....
# .....
# .....
# .....
# .....

# z=1, w=0
# .....
# .....
# .....
# .....
# .....

# z=2, w=0
# ###..
# ##.##
# #...#
# .#..#
# .###.

# z=-2, w=1
# .....
# .....
# .....
# .....
# .....

# z=-1, w=1
# .....
# .....
# .....
# .....
# .....

# z=0, w=1
# .....
# .....
# .....
# .....
# .....

# z=1, w=1
# .....
# .....
# .....
# .....
# .....

# z=2, w=1
# .....
# .....
# .....
# .....
# .....

# z=-2, w=2
# .....
# .....
# ..#..
# .....
# .....

# z=-1, w=2
# .....
# .....
# .....
# .....
# .....

# z=0, w=2
# ###..
# ##.##
# #...#
# .#..#
# .###.

# z=1, w=2
# .....
# .....
# .....
# .....
# .....

# z=2, w=2
# .....
# .....
# ..#..
# .....
# .....

# After the full six-cycle boot process completes, 848 cubes are left in the active state.

# Starting with your given initial configuration, simulate six cycles in a 4-dimensional space. How many cubes are left in the active state after the sixth cycle?

# Your puzzle answer was 1620.

class ConwayCubes
  alias Coord = {x: Int32, y: Int32, z: Int32}
  property map : Hash(Int32, Hash(Int32, Hash(Int32, Bool))) # y, x, z = active?
  property actives : Array(Coord)

  def initialize(@map, @actives)
  end

  def self.parse(cubes) : self
    map = Hash(Int32, Hash(Int32, Hash(Int32, Bool))).new
    actives = Array(Coord).new

    cubes.each_with_index do |rows, y|
      rows.chars.each_with_index do |col, x|
        c = Coord.new(x: x, y: y, z: 0)
        if col == '#'
          set(map, c, true)
          actives << c
        end
      end
    end

    return self.new(map, actives)
  end

  def cycle
    cells = Array(Coord).new
    actives.each do |active|
      cells += neighbours(active)
    end
    cells.uniq!

    new_map = Hash(Int32, Hash(Int32, Hash(Int32, Bool))).new
    new_actives = Array(Coord).new

    cells.each do |c|
      ns = neighbours(c)
      nscount = ns.select { |nc| cell(nc) }.size
      if cell(c)
        # current active
        if nscount > 2 && nscount < 5
          set(new_map, c, true)
          new_actives << c
        end
      else
        # current inactive

        if nscount == 3
          set(new_map, c, true)
          new_actives << c
        end
      end
    end

    @actives = new_actives
    @map = new_map
  end

  def neighbours(point : Coord) : Array(Coord)
    result = [] of Coord
    [point[:x] - 1, point[:x], point[:x] + 1].each do |x|
      [point[:y] - 1, point[:y], point[:y] + 1].each do |y|
        [point[:z] - 1, point[:z], point[:z] + 1].each do |z|
          result << Coord.new(x: x, y: y, z: z)
        end
      end
    end

    return result
  end

  def print
    zmin = 0
    zmax = 0
    @actives.each do |c|
      zmin = c[:z] if zmin > c[:z]
      zmax = c[:z] if zmax < c[:z]
    end

    zmin.upto(zmax) do |z|
      puts "z=#{z}"
      map.keys.sort.each do |y|
        map[y].keys.sort.each do |x|
          print (cell(x, y, z) ? '#' : '.')
        end
        puts
      end
      puts
    end
  end

  def cell(x, y, z)
    @map[y][x][z]
  rescue
    false
  end

  def cell(c : Coord)
    @map[c[:y]][c[:x]][c[:z]]
  rescue
    false
  end

  def set(map, c, val)
    map[c[:y]] = Hash(Int32, Hash(Int32, Bool)).new if !map.has_key?(c[:y])
    map[c[:y]][c[:x]] = Hash(Int32, Bool).new if !map[c[:y]].has_key?(c[:x])
    map[c[:y]][c[:x]][c[:z]] = val
  end

  def self.set(map, c, val)
    map[c[:y]] = Hash(Int32, Hash(Int32, Bool)).new if !map.has_key?(c[:y])
    map[c[:y]][c[:x]] = Hash(Int32, Bool).new if !map[c[:y]].has_key?(c[:x])
    map[c[:y]][c[:x]][c[:z]] = val
  end

  def active
    result = 0
    @map.each do |y, ys|
      ys.each do |x, xs|
        xs.each do |x, z|
          result += 1 if z
        end
      end
    end
    return result
  end
end

class ConwayCubes2
  alias Coord = {x: Int32, y: Int32, z: Int32, w: Int32}
  property map : Hash(Int32, Hash(Int32, Hash(Int32, Hash(Int32, Bool)))) # y, x, z, w = active?
  property actives : Array(Coord)

  def initialize(@map, @actives)
  end

  def self.parse(cubes) : self
    map = Hash(Int32, Hash(Int32, Hash(Int32, Hash(Int32, Bool)))).new
    actives = Array(Coord).new

    cubes.each_with_index do |rows, y|
      rows.chars.each_with_index do |col, x|
        c = Coord.new(x: x, y: y, z: 0, w: 0)
        if col == '#'
          set(map, c, true)
          actives << c
        end
      end
    end

    return self.new(map, actives)
  end

  def cycle
    cells = Array(Coord).new
    actives.each do |active|
      cells += neighbours(active)
    end
    cells.uniq!

    new_map = Hash(Int32, Hash(Int32, Hash(Int32, Hash(Int32, Bool)))).new
    new_actives = Array(Coord).new

    cells.each do |c|
      ns = neighbours(c)
      nscount = ns.select { |nc| cell(nc) }.size
      if cell(c)
        # current active
        if nscount > 2 && nscount < 5
          set(new_map, c, true)
          new_actives << c
        end
      else
        # current inactive

        if nscount == 3
          set(new_map, c, true)
          new_actives << c
        end
      end
    end

    @actives = new_actives
    @map = new_map
  end

  def neighbours(point : Coord) : Array(Coord)
    result = [] of Coord
    [point[:x] - 1, point[:x], point[:x] + 1].each do |x|
      [point[:y] - 1, point[:y], point[:y] + 1].each do |y|
        [point[:z] - 1, point[:z], point[:z] + 1].each do |z|
          [point[:w] - 1, point[:w], point[:w] + 1].each do |w|
            result << Coord.new(x: x, y: y, z: z, w: w)
          end
        end
      end
    end

    return result
  end

  def print
    zmin = 0
    zmax = 0
    @actives.each do |c|
      zmin = c[:z] if zmin > c[:z]
      zmax = c[:z] if zmax < c[:z]
    end

    wmin = 0
    wmax = 0
    @actives.each do |c|
      zmin = c[:w] if zmin > c[:w]
      zmax = c[:w] if zmax < c[:w]
    end

    wmin.upto(wmax) do |w|
      zmin.upto(zmax) do |z|
        puts "z=#{z}; w=#{w}"
        map.keys.sort.each do |y|
          map[y].keys.sort.each do |x|
            print (cell(x, y, z, w) ? '#' : '.')
          end
          puts
        end
        puts
      end
      puts
    end
  end

  def cell(x, y, z, w)
    @map[y][x][z][w]
  rescue
    false
  end

  def cell(c : Coord)
    @map[c[:y]][c[:x]][c[:z]][c[:w]]
  rescue
    false
  end

  def set(map, c, val)
    self.class.set(map, c, val)
  end

  def self.set(map, c, val)
    map[c[:y]] = Hash(Int32, Hash(Int32, Hash(Int32, Bool))).new if !map.has_key?(c[:y])
    map[c[:y]][c[:x]] = Hash(Int32, Hash(Int32, Bool)).new if !map[c[:y]].has_key?(c[:x])
    map[c[:y]][c[:x]][c[:z]] = Hash(Int32, Bool).new if !map[c[:y]][c[:x]].has_key?(c[:z])
    map[c[:y]][c[:x]][c[:z]][c[:w]] = val
  end

  def active
    result = 0
    @map.each do |y, ys|
      ys.each do |x, xs|
        xs.each do |z, zs|
          zs.each do |w, ws|
            result += 1 if ws
          end
        end
      end
    end
    return result
  end
end
