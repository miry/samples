# https://adventofcode.com/2019/day/3
#
# --- Day 3: Crossed Wires ---
#
# The gravity assist was successful, and you're well on your way to the Venus refuelling station. During the rush back on Earth, the fuel management system wasn't completely installed, so that's next on the priority list.
#
# Opening the front panel reveals a jumble of wires. Specifically, two wires are connected to a central port and extend outward on a grid. You trace the path each wire takes as it leaves the central port, one wire per line of text (your puzzle input).
#
# The wires twist and turn, but the two wires occasionally cross paths. To fix the circuit, you need to find the intersection point closest to the central port. Because the wires are on a grid, use the Manhattan distance for this measurement. While the wires do technically cross right at the central port where they both start, this point does not count, nor does a wire count as crossing with itself.
#
# For example, if the first wire's path is R8,U5,L5,D3, then starting from the central port (o), it goes right 8, up 5, left 5, and finally down 3:
#
# ...........
# ...........
# ...........
# ....+----+.
# ....|....|.
# ....|....|.
# ....|....|.
# .........|.
# .o-------+.
# ...........
#
# Then, if the second wire's path is U7,R6,D4,L4, it goes up 7, right 6, down 4, and left 4:
#
# ...........
# .+-----+...
# .|.....|...
# .|..+--X-+.
# .|..|..|.|.
# .|.-X--+.|.
# .|..|....|.
# .|.......|.
# .o-------+.
# ...........
#
# These wires cross at two locations (marked X), but the lower-left one is closer to the central port: its distance is 3 + 3 = 6.
#
# Here are a few more examples:
#
#     R75,D30,R83,U83,L12,D49,R71,U7,L72
#     U62,R66,U55,R34,D71,R55,D58,R83 = distance 159
#     R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
#     U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = distance 135
#
# What is the Manhattan distance from the central port to the closest intersection?

alias Coord = Tuple(Int32, Int32)
alias Line = Tuple(Coord, Coord)

class Wire
  getter horizonatls : Set(Line)
  getter verticals : Set(Line)

  def initialize(commands)
    @horizonatls = Set(Line).new
    @verticals = Set(Line).new
    @start_position = {0, 0}

    add(commands)
  end

  def add(commands : Array(String))
    position = @start_position
    commands.each do |command|
      x, y = step(command)
      new_position = {position[0] + x, position[1] + y}
      if x == 0
        @verticals << {position, new_position}
      else
        @horizonatls << {position, new_position}
      end
      position = new_position
    end
  end

  def intersection(other : Wire)
    result = Set(Coord).new
    # puts @verticals
    # puts @horizonatls
    @verticals.each do |vline|
      x = vline[0][0]
      y1, y2 = [vline[0][1], vline[1][1]].sort

      # p "vline: #{vline} #{x} #{y1} #{y2}"
      other.horizonatls.each do |hline|
        y = hline[0][1]
        x1, x2 = [hline[0][0], hline[1][0]].sort
        # p "hline: #{hline} #{y} #{x1} #{x2}"
        if x > x1 && x < x2 && y > y1 && y < y2
          result << {x, y}
        end
      end
    end

    other.verticals.each do |vline|
      x = vline[0][0]
      y1, y2 = [vline[0][1], vline[1][1]].sort

      # p "vline: #{vline} #{x} #{y1} #{y2}"
      @horizonatls.each do |hline|
        y = hline[0][1]
        x1, x2 = [hline[0][0], hline[1][0]].sort
        # p "hline: #{hline} #{y} #{x1} #{x2}"
        if x > x1 && x < x2 && y > y1 && y < y2
          result << {x, y}
        end
      end
    end

    result
  end

  def step(command)
    x = 0
    y = 0
    direction = command[0]
    steps = command[1..].to_i
    case direction
    when 'R'
      x = steps
    when 'L'
      x = -steps
    when 'D'
      y = -steps
    when 'U'
      y = steps
    end
    {x, y}
  end
end

class Grid
  def initialize
    @wires = Array(Wire).new(2)
  end

  def add(wire : Array(String))
    @wires << Wire.new(wire)
  end

  def intersections
    @wires[0].intersection(@wires[1])
  end

  def closest
    sets = intersections
    return nil if sets.size == 0
    coord = sets.first
    min = coord[0].abs + coord[1].abs
    sets.each do |coord|
      dist = coord[0].abs + coord[1].abs
      min = dist if min > dist && dist > 0
    end
    min
  end
end
