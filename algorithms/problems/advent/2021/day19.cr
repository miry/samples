# https://adventofcode.com/2021/day/19
#
# --- Day 19: ... ---
#

struct Beacon
end

class Scanner
  def initialize(beacons)
  end
end

alias CoordXYZ = Tuple(Int32, Int32, Int32)

def problem19(records : Array(String))
  coords = Array(Array(Tuple(Int32, Int32, Int32))).new
  scanner_coords = Array(Tuple(Int32, Int32, Int32)).new

  records.each do |line|
    if line.empty?
      coords << scanner_coords
      scanner_coords = Array(Tuple(Int32, Int32, Int32)).new
    else
      p line
      if line.includes?("---")
        scanner_coords = Array(Tuple(Int32, Int32, Int32)).new
        next
      end

      x, y, z = line.split(",").map(&.to_i32)
      scanner_coords << {x, y, z}
    end
  end
  coords << scanner_coords unless scanner_coords.empty?

  beacons_distances = Array(Hash(Tuple(CoordXYZ, CoordXYZ), Float64)).new
  coords.each do |beacons|
    distances = Hash(CoordXYZ, Hash(CoordXYZ, Float64)).new
    n = beacons.size
    beacons.each_with_index do |beacon, i|
      distances[beacon] ||= Hash(CoordXYZ, Float64).new
      (i + 1).upto(n - 1) do |j|
        other = beacons[j]
        dist = Math.sqrt((other[0] - beacon[0])**2 + (other[1] - beacon[1])**2 + (other[2] - beacon[2])**2)
        distances[beacon][other] = dist
        distances[other] ||= Hash(CoordXYZ, Float64).new
        distances[other][beacon] = dist
      end
    end
    beacons_distances << distances
  end

  result = coords.reduce { |a, s| p merge_beacons(a, s) }

  return result.size
end

def merge_beacons(probe1, probe2, distances)
  distances1 = probe1.values

  # first beacon1
  probe2_beacons_sample =
    probe2.each do |beacons, dist|
      if distances1.has_key?(dist)
        beacon1 = distances1[dist][0]
        break
      end
    end

  result = probe1.dup
  probe2.each do |beacons, dist|
    if distances1.has_key?(dist)
      # puts "dist common found for #{distances1[dist]} and #{beacons}"
    else
      result[beacons] = dist
    end
  end
  return result
end

# --- Part Two ---

def problem19_part_two(records : Array(String))
  raise "not implemented"
end
