require "option_parser"
require "./day_one"

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
  case task
  when 0
    raise "Missing required argument: -d <DAY>"
  when 1.1
    puts "--- Day 1: Report Repair ---"
    puts "--- Part One ---"
    puts "What is the sum of the fuel requirements for all of the modules on your spacecraft?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = mul_two_entries_to_sum(entries, 2020)
    puts "Answer: #{answer}"
  when 1.2
    puts "--- Day 1: Report Repair ---"
    puts "--- Part Two ---"
    puts "In your expense report, what is the product of the three entries that sum to 2020?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = mul_entries_to_sum(entries, 3, 2020)
    puts "Answer: #{answer}"
  else
    raise "Day is not implemented"
  end
end

elapsed_time = Time.measure do
  run()
end
puts "(execute time: #{elapsed_time})"
