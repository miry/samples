require "option_parser"
require "./day_one"
require "./day_two"

def run
  exit = false
  day : Int64 = 0

  OptionParser.parse do |parser|
    parser.banner = "Usage: advent [arguments]"
    parser.on("-d DAY", "--day=DAY", "Advent Day from 1 to 25. E.g: 1") { |d| day = d.to_i64 }
    parser.on("-h", "--help", "Show this help") { puts parser; exit = true }

    parser.unknown_args do |before, after|
      msg = (before | after).join(" ")
    end
  end

  return if exit

  if day == 0

  end

  case day
  when 0
    raise "Missing required argument: -d <DAY>"
  when 1
    puts "--- Day 1: The Tyranny of the Rocket Equation ---"
    puts "What is the sum of the fuel requirements for all of the modules on your spacecraft?"
    modules_mass = [] of Int64
    STDIN.each_line do |line|
      modules_mass << line.to_i64
    end

    answer = fuel_requirement(modules_mass)
    puts "Answer: #{answer}"
  when 2
    puts "--- Day 2: 1202 Program Alarm ---"
    puts "What value is left at position 0 after the program halts?"
    commands = [] of Int64
    STDIN.each_line do |line|
      commands = line.split(",").map {|a| a.to_i64 }
    end

    answer = Computer.detect_inputs(commands, 19690720)
    puts "Answer: #{answer}"
  else
    raise "Day should be from 1 to 25"
  end
end

run()
