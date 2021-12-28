require "option_parser"
require "big"

require "./utils"

require "./day1"
require "./day2"
require "./day3"
require "./day4"
require "./day5"
require "./day6"
require "./day7"
require "./day8"
require "./day9"
require "./day10"
require "./day11"
require "./day12"
require "./day13"
require "./day14"
require "./day15"
require "./day16"
require "./day17"
require "./day18"
require "./day19"
require "./day20"
require "./day21"
require "./day22"
require "./day23"
require "./day24"
require "./day25"

def run
  exit = false
  day : Int64 = 0
  part : Int64 = 1

  OptionParser.parse do |parser|
    parser.banner = "Usage: advent [arguments]"
    parser.on("-d DAY", "--day=DAY", "Advent Day from 1 to 25. E.g: 1") { |d| day = d.to_i64 }
    parser.on("-p PART", "--part=PART", "Advent Day Part from 1 to 2. Default: 1") { |p| part = p.to_i64 }
    parser.on("-h", "--help", "Show this help") { puts parser; exit = true }

    parser.unknown_args do |before, after|
      msg = (before | after).join(" ")
    end
  end

  return if exit

  if day < 0 && day > 24
    raise "Day should be from 1 to 25"
  end

  if part != 1 && part != 2
    raise "Part should be 1 or 2"
  end

  task = day + 0.1 * part
  answer = 0
  case task
  when 0
    raise "Missing required argument: -d <DAY>"
  when 1.1
    puts "--- Day 1: Sonar Sweep ---"
    puts "--- Part One ---"
    puts "How many measurements are larger than the previous measurement?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = increased_values(entries)
  when 1.2
    puts "--- Day 1: Sonar Sweep ---"
    puts "--- Part Two ---"
    puts "Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = increased_moving_window(entries, 3)
  when 2.1
    puts "--- Day 2: Dive ---"
    puts "--- Part One ---"
    puts "What do you get if you multiply your final horizontal position by your final depth?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem2(entries)
  when 2.2
    puts "--- Day 2: Dive ---"
    puts "--- Part Two ---"
    puts "What do you get if you multiply your final horizontal position by your final depth?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem2_part_two(entries)
  when 3.1
    puts "--- Day 3: Binary Diagnostic ---"
    puts "--- Part One ---"
    puts "What is the power consumption of the submarine?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem3(entries)
  when 3.2
    puts "--- Day 3: Binary Diagnostic ---"
    puts "--- Part Two ---"
    puts "What is the life support rating of the submarine?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem3_part_two(entries)
  when 4.1
    puts "--- Day 4: Giant Squid ---"
    puts "--- Part One ---"
    puts "What will your final score be if you choose that board?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem4(entries)
  when 4.2
    puts "--- Day 4: Giant Squid ---"
    puts "--- Part Two ---"
    puts "Once it wins, what would its final score be?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem4_part_two(entries)
  when 5.1
    puts "--- Day 5: Hydrothermal Venture ---"
    puts "--- Part One ---"
    puts "At how many points do at least two lines overlap?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem5(entries)
  when 5.2
    puts "--- Day 5: Hydrothermal Venture ---"
    puts "--- Part Two ---"
    puts "At how many points do at least two lines overlap?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem5_part_two(entries)
  when 6.1
    puts "--- Day 6: Lanternfish ---"
    puts "--- Part One ---"
    puts "How many lanternfish would there be after 80 days?"
    entries = STDIN.gets || ""
    answer = problem6(entries, 80_i64)
  when 6.2
    puts "--- Day 6: Lanternfish ---"
    puts "--- Part Two ---"
    puts "How many lanternfish would there be after 256 days?"
    entries = STDIN.gets || ""
    answer = problem6(entries, 256_i64)
  when 7.1
    puts "--- Day 7: The Treachery of Whales ---"
    puts "--- Part One ---"
    puts "How much fuel must they spend to align to that position?"
    entries = STDIN.gets || ""

    answer = problem7(entries)
  when 7.2
    puts "--- Day 7: The Treachery of Whales ---"
    puts "--- Part Two ---"
    puts "How much fuel must they spend to align to that position?"
    entries = STDIN.gets || ""

    answer = problem7_part_two(entries)
  when 8.1
    puts "--- Day 8: Seven Segment Search ---"
    puts "--- Part One ---"
    puts "In the output values, how many times do digits 1, 4, 7, or 8 appear?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem8(entries)
  when 8.2
    puts "--- Day 8: Seven Segment Search ---"
    puts "--- Part Two ---"
    puts "What do you get if you add up all of the output values?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem8_part_two(entries)
  when 9.1
    puts "--- Day 9: Smoke Basin ---"
    puts "--- Part One ---"
    puts "What is the sum of the risk levels of all low points on your heightmap?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem9(entries)
  when 9.2
    puts "--- Day 9: Smoke Basin ---"
    puts "--- Part Two ---"
    puts "What do you get if you multiply together the sizes of the three largest basins?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem9_part_two(entries)
  when 10.1
    puts "--- Day 10: Syntax Scoring ---"
    puts "--- Part One ---"
    puts "What is the total syntax error score for those errors?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem10(entries)
  when 10.2
    puts "--- Day 10: Syntax Scoring ---"
    puts "--- Part Two ---"
    puts "What is the middle score?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem10_part_two(entries)
  when 11.1
    puts "--- Day 11: Dumbo Octopus ---"
    puts "--- Part One ---"
    puts "How many total flashes are there after 100 steps?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem11(entries)
  when 11.2
    puts "--- Day 11: Dumbo Octopus ---"
    puts "--- Part Two ---"
    puts "What is the first step during which all octopuses flash?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem11_part_two(entries)
  when 12.1
    puts "--- Day 12: Passage Pathing ---"
    puts "--- Part One ---"
    puts "How many paths through this cave system are there that visit small caves at most once?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem12(entries)
  when 12.2
    puts "--- Day 12: Passage Pathing ---"
    puts "--- Part Two ---"
    puts "How many paths through this cave system are there?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem12_part_two(entries)
  when 13.1
    puts "--- Day 13: Transparent Origami ---"
    puts "--- Part One ---"
    puts "How many dots are visible after completing just the first fold instruction on your transparent paper?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem13(entries)
  when 13.2
    puts "--- Day 13: Transparent Origami ---"
    puts "--- Part Two ---"
    puts "What code do you use to activate the infrared thermal imaging camera system?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem13_part_two(entries)
  when 14.1
    puts "--- Day 14: Extended Polymerization ---"
    puts "--- Part One ---"
    puts "What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem14(entries, 10)
  when 14.2
    puts "--- Day 14: Extended Polymerization ---"
    puts "--- Part Two ---"
    puts "What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem14(entries, 40)
  when 15.1
    puts "--- Day 15: Chiton ---"
    puts "--- Part One ---"
    puts "What is the lowest total risk of any path from the top left to the bottom right?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem15(entries)
  when 15.2
    puts "--- Day 15: Chiton ---"
    puts "--- Part Two ---"
    puts "What is the lowest total risk of any path from the top left to the bottom right?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem15_part_two(entries)
  when 16.1
    puts "--- Day 16: Packet Decoder ---"
    puts "--- Part One ---"
    puts "What do you get if you add up the version numbers in all packets?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem16(entries.first)
  when 16.2
    puts "--- Day 16: Packet Decoder ---"
    puts "--- Part Two ---"
    puts "What do you get if you evaluate the expression represented by your hexadecimal-encoded BITS transmission?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem16_part_two(entries.first)
  when 17.1
    puts "--- Day 17: Trick Shot ---"
    puts "--- Part One ---"
    puts "What is the highest y position it reaches on this trajectory?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem17(entries.first)
  when 17.2
    puts "--- Day 17: Trick Shot ---"
    puts "--- Part Two ---"
    puts "How many distinct initial velocity values cause the probe to be within the target area after any step?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem17_part_two(entries.first)
  when 18.1
    puts "--- Day 18: Snailfish ---"
    puts "--- Part One ---"
    puts "What is the magnitude of the final sum?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem18(entries)
  when 18.2
    puts "--- Day 18: Snailfish ---"
    puts "--- Part Two ---"
    puts "What is the largest magnitude of any sum of two different snailfish numbers from the homework assignment?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem18_part_two(entries)
  when 19.1
    puts "--- Day 19: Beacon Scanner ---"
    puts "--- Part One ---"
    puts "How many beacons are there?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem19(entries)
  when 19.2
    puts "--- Day 19: Beacon Scanner ---"
    puts "--- Part Two ---"
    puts "What is the largest Manhattan distance between any two scanners?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem19_part_two(entries)
  when 20.1
    puts "--- Day 20: Sonar Sweep ---"
    puts "--- Part One ---"
    puts "How many measurements are larger than the previous measurement?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem20(entries)
  when 20.2
    puts "--- Day 20: Sonar Sweep ---"
    puts "--- Part Two ---"
    puts "Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem20_part_two(entries)
  when 21.1
    puts "--- Day 21: Dirac Dice ---"
    puts "--- Part One ---"
    puts "What do you get if you multiply the score of the losing player by the number of times the die was rolled during the game?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem21(entries)
  when 21.2
    puts "--- Day 21: Dirac Dice ---"
    puts "--- Part Two ---"
    puts "Find the player that wins in more universes; in how many universes does that player win?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem21_part_two(entries)
  when 22.1
    puts "--- Day 22: Sonar Sweep ---"
    puts "--- Part One ---"
    puts "How many measurements are larger than the previous measurement?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem22(entries)
  when 22.2
    puts "--- Day 22: Sonar Sweep ---"
    puts "--- Part Two ---"
    puts "Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem22_part_two(entries)
  when 23.1
    puts "--- Day 23: Sonar Sweep ---"
    puts "--- Part One ---"
    puts "How many measurements are larger than the previous measurement?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = problem23(entries)
  when 23.2
    puts "--- Day 23: Sonar Sweep ---"
    puts "--- Part Two ---"
    puts "Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = problem23_part_two(entries)
  when 24.1
    puts "--- Day 24: Sonar Sweep ---"
    puts "--- Part One ---"
    puts "How many measurements are larger than the previous measurement?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem24(entries)
  when 24.2
    puts "--- Day 24: Sonar Sweep ---"
    puts "--- Part Two ---"
    puts "Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem24_part_two(entries)
  when 25.1
    puts "--- Day 25: Sea Cucumber ---"
    puts "--- Part One ---"
    puts "What is the first step on which no sea cucumbers move?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = problem25(entries)
  else
    raise "Day is not implemented"
  end
  puts "Answer: #{answer}"
end

elapsed_time = Time.measure do
  run()
end
puts "(execute time: #{elapsed_time})"
