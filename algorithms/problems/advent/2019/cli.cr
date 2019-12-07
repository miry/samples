require "option_parser"
require "./day_one"
require "./day_two"
require "./day_three"
require "./day_four"
require "./day_five"
require "./day_six"

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

    answer = fuel2_requirement(modules_mass)
    puts "Answer: #{answer}"
  when 2
    puts "--- Day 2: 1202 Program Alarm ---"
    puts "What value is left at position 0 after the program halts?"
    commands = [] of Int64
    STDIN.each_line do |line|
      commands = line.split(",").map { |a| a.to_i64 }
    end

    answer = Computer.detect_inputs(commands, 19690720)
    puts "Answer: #{answer}"
  when 3
    puts "--- Day 3: Crossed Wires ---"
    puts "What is the Manhattan distance from the central port to the closest intersection?"
    grid = Grid.new

    STDIN.each_line do |line|
      grid.add(line.split(","))
    end

    answer = grid.closest
    puts "Answer: #{answer}"
  when 4
    puts "--- Day 4: Secure Container ---"
    puts "How many different passwords within the range given in your puzzle input meet these criteria?"

    range = Array(Int32).new(2)
    STDIN.each_line do |line|
      range = line.split("-").map { |a| a.to_i32 }
    end

    answer = brute_force(range[0], range[1])
    puts "Part 1 Answer: #{answer}"

    answer = brute_force2(range[0], range[1])
    puts "Part 2 Answer: #{answer}"
  when 5
    puts "--- Day 5: Sunny with a Chance of Asteroids ---"
    puts "what diagnostic code does the program produce?"
    commands = [] of Int64
    STDIN.each_line do |line|
      commands = line.split(",").map { |a| a.to_i64 }
    end

    computer = AirCondition.new(commands)
    computer.perform
    answer = computer.output[-1]
    puts "Answer: #{answer}"
  when 6
    puts "--- Day 6: Universal Orbit Map ---"
    puts "What is the total number of direct and indirect orbits in your map data?"
    input = [] of String
    STDIN.each_line do |line|
      input << line
    end

    computer = OrbitsMap.new(input)
    # answer = computer.all_orbits
    # puts "Answer: #{answer}"

    answer = computer.distance_between("YOU", "SAN")
    puts "Answer: #{answer}"
  else
    raise "Day should be from 1 to 25"
  end
end

run()
