# https://adventofcode.com/2021/day/19
#
# --- Day 19: Beacon Scanner ---
#
# As your probe drifted down through this area, it released an assortment of beacons and scanners into the water. It's difficult to navigate in the pitch black open waters of the ocean trench, but if you can build a map of the trench using data from the scanners, you should be able to safely reach the bottom.
#
# The beacons and scanners float motionless in the water; they're designed to maintain the same position for long periods of time. Each scanner is capable of detecting all beacons in a large cube centered on the scanner; beacons that are at most 1000 units away from the scanner in each of the three axes (x, y, and z) have their precise position determined relative to the scanner. However, scanners cannot detect other scanners. The submarine has automatically summarized the relative positions of beacons detected by each scanner (your puzzle input).
#
# For example, if a scanner is at x,y,z coordinates 500,0,-500 and there are beacons at -500,1000,-1500 and 1501,0,-500, the scanner could report that the first beacon is at -1000,1000,-1000 (relative to the scanner) but would not detect the second beacon at all.
#
# Unfortunately, while each scanner can report the positions of all detected beacons relative to itself, the scanners do not know their own position. You'll need to determine the positions of the beacons and scanners yourself.
#
# The scanners and beacons map a single contiguous 3d region. This region can be reconstructed by finding pairs of scanners that have overlapping detection regions such that there are at least 12 beacons that both scanners detect within the overlap. By establishing 12 common beacons, you can precisely determine where the scanners are relative to each other, allowing you to reconstruct the beacon map one scanner at a time.
#
# For a moment, consider only two dimensions. Suppose you have the following scanner reports:
#
# --- scanner 0 ---
# 0,2
# 4,1
# 3,3
#
# --- scanner 1 ---
# -1,-1
# -5,0
# -2,1
#
# Drawing x increasing rightward, y increasing upward, scanners as S, and beacons as B, scanner 0 detects this:
#
# ...B.
# B....
# ....B
# S....
#
# Scanner 1 detects this:
#
# ...B..
# B....S
# ....B.
#
# For this example, assume scanners only need 3 overlapping beacons. Then, the beacons visible to both scanners overlap to produce the following complete map:
#
# ...B..
# B....S
# ....B.
# S.....
#
# Unfortunately, there's a second problem: the scanners also don't know their rotation or facing direction. Due to magnetic alignment, each scanner is rotated some integer number of 90-degree turns around all of the x, y, and z axes. That is, one scanner might call a direction positive x, while another scanner might call that direction negative y. Or, two scanners might agree on which direction is positive x, but one scanner might be upside-down from the perspective of the other scanner. In total, each scanner could be in any of 24 different orientations: facing positive or negative x, y, or z, and considering any of four directions "up" from that facing.
#
# For example, here is an arrangement of beacons as seen from a scanner in the same position but in different orientations:
#
# --- scanner 0 ---
# -1,-1,1
# -2,-2,2
# -3,-3,3
# -2,-3,1
# 5,6,-4
# 8,0,7
#
# --- scanner 0 ---
# 1,-1,1
# 2,-2,2
# 3,-3,3
# 2,-1,3
# -5,4,-6
# -8,-7,0
#
# --- scanner 0 ---
# -1,-1,-1
# -2,-2,-2
# -3,-3,-3
# -1,-3,-2
# 4,6,5
# -7,0,8
#
# --- scanner 0 ---
# 1,1,-1
# 2,2,-2
# 3,3,-3
# 1,3,-2
# -4,-6,5
# 7,0,8
#
# --- scanner 0 ---
# 1,1,1
# 2,2,2
# 3,3,3
# 3,1,2
# -6,-4,-5
# 0,7,-8
#
# By finding pairs of scanners that both see at least 12 of the same beacons, you can assemble the entire map. For example, consider the following report:
#
# --- scanner 0 ---
# 404,-588,-901
# 528,-643,409
# -838,591,734
# 390,-675,-793
# -537,-823,-458
# -485,-357,347
# -345,-311,381
# -661,-816,-575
# -876,649,763
# -618,-824,-621
# 553,345,-567
# 474,580,667
# -447,-329,318
# -584,868,-557
# 544,-627,-890
# 564,392,-477
# 455,729,728
# -892,524,684
# -689,845,-530
# 423,-701,434
# 7,-33,-71
# 630,319,-379
# 443,580,662
# -789,900,-551
# 459,-707,401
#
# --- scanner 1 ---
# 686,422,578
# 605,423,415
# 515,917,-361
# -336,658,858
# 95,138,22
# -476,619,847
# -340,-569,-846
# 567,-361,727
# -460,603,-452
# 669,-402,600
# 729,430,532
# -500,-761,534
# -322,571,750
# -466,-666,-811
# -429,-592,574
# -355,545,-477
# 703,-491,-529
# -328,-685,520
# 413,935,-424
# -391,539,-444
# 586,-435,557
# -364,-763,-893
# 807,-499,-711
# 755,-354,-619
# 553,889,-390
#
# --- scanner 2 ---
# 649,640,665
# 682,-795,504
# -784,533,-524
# -644,584,-595
# -588,-843,648
# -30,6,44
# -674,560,763
# 500,723,-460
# 609,671,-379
# -555,-800,653
# -675,-892,-343
# 697,-426,-610
# 578,704,681
# 493,664,-388
# -671,-858,530
# -667,343,800
# 571,-461,-707
# -138,-166,112
# -889,563,-600
# 646,-828,498
# 640,759,510
# -630,509,768
# -681,-892,-333
# 673,-379,-804
# -742,-814,-386
# 577,-820,562
#
# --- scanner 3 ---
# -589,542,597
# 605,-692,669
# -500,565,-823
# -660,373,557
# -458,-679,-417
# -488,449,543
# -626,468,-788
# 338,-750,-386
# 528,-832,-391
# 562,-778,733
# -938,-730,414
# 543,643,-506
# -524,371,-870
# 407,773,750
# -104,29,83
# 378,-903,-323
# -778,-728,485
# 426,699,580
# -438,-605,-362
# -469,-447,-387
# 509,732,623
# 647,635,-688
# -868,-804,481
# 614,-800,639
# 595,780,-596
#
# --- scanner 4 ---
# 727,592,562
# -293,-554,779
# 441,611,-461
# -714,465,-776
# -743,427,-804
# -660,-479,-426
# 832,-632,460
# 927,-485,-438
# 408,393,-506
# 466,436,-512
# 110,16,151
# -258,-428,682
# -393,719,612
# -211,-452,876
# 808,-476,-593
# -575,615,604
# -485,667,467
# -680,325,-822
# -627,-443,-432
# 872,-547,-609
# 833,512,582
# 807,604,487
# 839,-516,451
# 891,-625,532
# -652,-548,-490
# 30,-46,-14
#
# Because all coordinates are relative, in this example, all "absolute" positions will be expressed relative to scanner 0 (using the orientation of scanner 0 and as if scanner 0 is at coordinates 0,0,0).
#
# Scanners 0 and 1 have overlapping detection cubes; the 12 beacons they both detect (relative to scanner 0) are at the following coordinates:
#
# -618,-824,-621
# -537,-823,-458
# -447,-329,318
# 404,-588,-901
# 544,-627,-890
# 528,-643,409
# -661,-816,-575
# 390,-675,-793
# 423,-701,434
# -345,-311,381
# 459,-707,401
# -485,-357,347
#
# These same 12 beacons (in the same order) but from the perspective of scanner 1 are:
#
# 686,422,578
# 605,423,415
# 515,917,-361
# -336,658,858
# -476,619,847
# -460,603,-452
# 729,430,532
# -322,571,750
# -355,545,-477
# 413,935,-424
# -391,539,-444
# 553,889,-390
#
# Because of this, scanner 1 must be at 68,-1246,-43 (relative to scanner 0).
#
# Scanner 4 overlaps with scanner 1; the 12 beacons they both detect (relative to scanner 0) are:
#
# 459,-707,401
# -739,-1745,668
# -485,-357,347
# 432,-2009,850
# 528,-643,409
# 423,-701,434
# -345,-311,381
# 408,-1815,803
# 534,-1912,768
# -687,-1600,576
# -447,-329,318
# -635,-1737,486
#
# So, scanner 4 is at -20,-1133,1061 (relative to scanner 0).
#
# Following this process, scanner 2 must be at 1105,-1205,1229 (relative to scanner 0) and scanner 3 must be at -92,-2380,-20 (relative to scanner 0).
#
# The full list of beacons (relative to scanner 0) is:
#
# -892,524,684
# -876,649,763
# -838,591,734
# -789,900,-551
# -739,-1745,668
# -706,-3180,-659
# -697,-3072,-689
# -689,845,-530
# -687,-1600,576
# -661,-816,-575
# -654,-3158,-753
# -635,-1737,486
# -631,-672,1502
# -624,-1620,1868
# -620,-3212,371
# -618,-824,-621
# -612,-1695,1788
# -601,-1648,-643
# -584,868,-557
# -537,-823,-458
# -532,-1715,1894
# -518,-1681,-600
# -499,-1607,-770
# -485,-357,347
# -470,-3283,303
# -456,-621,1527
# -447,-329,318
# -430,-3130,366
# -413,-627,1469
# -345,-311,381
# -36,-1284,1171
# -27,-1108,-65
# 7,-33,-71
# 12,-2351,-103
# 26,-1119,1091
# 346,-2985,342
# 366,-3059,397
# 377,-2827,367
# 390,-675,-793
# 396,-1931,-563
# 404,-588,-901
# 408,-1815,803
# 423,-701,434
# 432,-2009,850
# 443,580,662
# 455,729,728
# 456,-540,1869
# 459,-707,401
# 465,-695,1988
# 474,580,667
# 496,-1584,1900
# 497,-1838,-617
# 527,-524,1933
# 528,-643,409
# 534,-1912,768
# 544,-627,-890
# 553,345,-567
# 564,392,-477
# 568,-2007,-577
# 605,-1665,1952
# 612,-1593,1893
# 630,319,-379
# 686,-3108,-505
# 776,-3184,-501
# 846,-3110,-434
# 1135,-1161,1235
# 1243,-1093,1063
# 1660,-552,429
# 1693,-557,386
# 1735,-437,1738
# 1749,-1800,1813
# 1772,-405,1572
# 1776,-675,371
# 1779,-442,1789
# 1780,-1548,337
# 1786,-1538,337
# 1847,-1591,415
# 1889,-1729,1762
# 1994,-1805,1792
#
# In total, there are 79 beacons.
#
# Assemble the full map of beacons. How many beacons are there?
#
# Your puzzle answer was 419.
# --- Part Two ---
#
# Sometimes, it's a good idea to appreciate just how big the ocean is. Using the Manhattan distance, how far apart do the scanners get?
#
# In the above example, scanners 2 (1105,-1205,1229) and 3 (-92,-2380,-20) are the largest Manhattan distance apart. In total, they are 1197 + 1175 + 1249 = 3621 units apart.
#
# What is the largest Manhattan distance between any two scanners?
#
# Your puzzle answer was 13210.

alias CoordXYZ = Tuple(Int32, Int32, Int32)

struct Beacon
  property x : Int32, y : Int32, z : Int32

  def initialize(@x, @y, @z)
  end

  def dist(other : Beacon) : Float64
    Math.sqrt((other.x - x)**2 + (other.y - y)**2 + (other.z - z)**2)
  end

  def coord
    {@x, @y, @z}
  end

  def hash
    {@x, @y, @z}.hash
  end
end

class Scanner
  property orientation : Tuple(Int32, Int32, Int32, Int32, Int32, Int32)
  property beacons : Array(Beacon)
  property coord : CoordXYZ

  def initialize(@beacons)
    @beacon_distances = Hash(Float64, Array(Tuple(Beacon, Beacon))).new
    @orientation = {1, 1, 1, 0, 1, 2}
    @coord = {0, 0, 0}
  end

  def distances
    return @beacon_distances if !@beacon_distances.empty?

    n = @beacons.size
    @beacons.each_with_index do |beacon, i|
      (i + 1).upto(n - 1) do |j|
        other = beacons[j]
        dist = beacon.dist(other)
        @beacon_distances[dist] ||= Array(Tuple(Beacon, Beacon)).new
        @beacon_distances[dist] << {beacon, other}
      end
    end

    return @beacon_distances
  end

  def merge(other)
    return false if !detect_scanner_coord(other)
    other.beacons_against_coord.each do |b|
      if !@beacons.includes?(b)
        @beacons << b
      end
    end
    @beacon_distances = Hash(Float64, Array(Tuple(Beacon, Beacon))).new
    distances
    return true
  end

  def overlap(other)
    dists = distances
    possible = Hash(Beacon, Array(Beacon)).new
    other.distances.each do |dist, connections|
      next if !dists.has_key?(dist)
      dists[dist].map(&.to_a).flatten.each do |b|
        if !possible.has_key?(b)
          possible[b] = connections.map(&.to_a).flatten
        else
          # p possible[b]
          possible[b] &= connections.map(&.to_a).flatten
        end
      end
    end

    result = Hash(Beacon, Beacon).new
    possible.each do |k, v|
      if v.size == 1
        result[k] = v.first
      end
    end

    return result
  end

  def detect_scanner_coord(other)
    common = overlap(other)
    return false if common.size < 12

    all_coords = Array(Set(Tuple(Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32))).new

    orientations = Hash(CoordXYZ, Tuple(Int32, Int32, Int32, Int32)).new
    common.each do |map|
      a, b = map
      coords = Set(Tuple(Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32, Int32)).new
      [
        {-1, -1, -1, 0, 1, 2},
        {-1, -1, 1, 0, 1, 2},
        {-1, 1, -1, 0, 1, 2},
        {-1, 1, 1, 0, 1, 2},
        {1, -1, -1, 0, 1, 2},
        {1, -1, 1, 0, 1, 2},
        {1, 1, -1, 0, 1, 2},
        {1, 1, 1, 0, 1, 2},

        {-1, -1, -1, 0, 2, 1},
        {-1, -1, 1, 0, 2, 1},
        {-1, 1, -1, 0, 2, 1},
        {-1, 1, 1, 0, 2, 1},
        {1, -1, -1, 0, 2, 1},
        {1, -1, 1, 0, 2, 1},
        {1, 1, -1, 0, 2, 1},
        {1, 1, 1, 0, 2, 1},

        {-1, -1, -1, 1, 2, 0},
        {-1, -1, 1, 1, 2, 0},
        {-1, 1, -1, 1, 2, 0},
        {-1, 1, 1, 1, 2, 0},
        {1, -1, -1, 1, 2, 0},
        {1, -1, 1, 1, 2, 0},
        {1, 1, -1, 1, 2, 0},
        {1, 1, 1, 1, 2, 0},

        {-1, -1, -1, 1, 0, 2},
        {-1, -1, 1, 1, 0, 2},
        {-1, 1, -1, 1, 0, 2},
        {-1, 1, 1, 1, 0, 2},
        {1, -1, -1, 1, 0, 2},
        {1, -1, 1, 1, 0, 2},
        {1, 1, -1, 1, 0, 2},
        {1, 1, 1, 1, 0, 2},

        {-1, -1, -1, 2, 0, 1},
        {-1, -1, 1, 2, 0, 1},
        {-1, 1, -1, 2, 0, 1},
        {-1, 1, 1, 2, 0, 1},
        {1, -1, -1, 2, 0, 1},
        {1, -1, 1, 2, 0, 1},
        {1, 1, -1, 2, 0, 1},
        {1, 1, 1, 2, 0, 1},

        {-1, -1, -1, 2, 1, 0},
        {-1, -1, 1, 2, 1, 0},
        {-1, 1, -1, 2, 1, 0},
        {-1, 1, 1, 2, 1, 0},
        {1, -1, -1, 2, 1, 0},
        {1, -1, 1, 2, 1, 0},
        {1, 1, -1, 2, 1, 0},
        {1, 1, 1, 2, 1, 0},
      ].each do |d|
        a_coord = a.coord
        b_coord = b.coord
        x = a.x - d[0] * b_coord[d[3]]
        y = a.y - d[1] * b_coord[d[4]]
        z = a.z - d[2] * b_coord[d[5]]
        coords << ({x, y, z} + d)
      end
      all_coords << coords
    end
    begin
      scaner_coord = all_coords.reduce { |a, s| a & s }.first
    rescue ex
      puts ex

      puts "common:"
      puts common.join("\n")
      puts "----"

      raise ex
    end
    other.coord = scaner_coord[0..2]
    other.orientation = scaner_coord[3..]

    # puts "other.orientation: #{other.orientation}"
    return true
  end

  def beacons_against_coord
    @beacons.map do |b|
      b_coord = b.coord
      Beacon.new(
        orientation[0]*b_coord[orientation[3]] + coord[0],
        orientation[1]*b_coord[orientation[4]] + coord[1],
        orientation[2]*b_coord[orientation[5]] + coord[2])
    end
  end

  def self.parse(input : Array(String)) : Array(self)
    beacons = Array(Beacon).new
    scanners = Array(Scanner).new

    input.each do |line|
      if line.empty?
        scanners << Scanner.new(beacons)
        beacons = Array(Beacon).new
      else
        if line.includes?("---")
          beacons = Array(Beacon).new
          next
        end

        x, y, z = line.split(",").map(&.to_i32)
        beacons << Beacon.new(x, y, z)
      end
    end
    scanners << Scanner.new(beacons) unless beacons.empty?
    return scanners
  end
end

def problem19(input : Array(String))
  scanners = Scanner.parse(input)

  processed = Set(Int32).new
  processed.add(0)
  s = scanners[0]
  while processed.size < scanners.size
    # puts "step #{processed.size}"
    found = false
    scanners.each_with_index do |s2, i|
      next if processed.includes?(i)
      common = s.overlap(s2)
      if common.size > 11
        found = true
        s.merge(scanners[i])
        processed.add(i)
        break
      end
    end
    if !found
      p processed
      raise "no overlaps"
    end
  end

  return s.beacons.size
end

# --- Part Two ---

def problem19_part_two(input : Array(String))
  scanners = Scanner.parse(input)

  processed = Set(Int32).new
  processed.add(0)
  s = scanners[0]
  while processed.size < scanners.size
    # puts "step #{processed.size}"
    found = false
    scanners.each_with_index do |s2, i|
      next if processed.includes?(i)
      common = s.overlap(s2)
      if common.size > 11
        found = true
        s.merge(scanners[i])
        processed.add(i)
        break
      end
    end
    if !found
      p processed
      raise "no overlaps"
    end
  end

  max = 0

  scanners.each_with_index do |s1, i|
    s1coord = s1.coord
    scanners.each_with_index do |s2, j|
      next if i <= j
      s2coord = s2.coord
      dist = (s2coord[0] - s1coord[0]).abs + (s2coord[1] - s1coord[1]).abs + (s2coord[2] - s1coord[2]).abs
      max = dist if dist > max
    end
  end

  return max
end
