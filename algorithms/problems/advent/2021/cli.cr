require "option_parser"
require "big"

require "./day1"

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
  else
    raise "Day is not implemented"
  end
  puts "Answer: #{answer}"
end

elapsed_time = Time.measure do
  run()
end
puts "(execute time: #{elapsed_time})"
