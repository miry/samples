require "option_parser"
require "./day_one"
require "./day_two"
require "./day_three"
require "./day_four"
require "./day_five"
require "./day_six"
require "./day_seven"
require "./day_eight"
require "./day_nine"
require "./day_ten"
require "./day_eleven"
require "./day_twelve"
require "./day_thirteen"

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
  when 7
    puts "--- Day 7: Amplification Circuit ---"
    puts "What is the highest signal that can be sent to the thrusters?"
    commands = [] of Int64
    STDIN.each_line do |line|
      commands = line.split(",").map { |a| a.to_i64 }
    end

    phases = Array.new(5) { |i| i.to_i64 }
    answer = Amplifier.max_thruster(commands, phases)
    puts "part 1 Answer: #{answer}"

    phases = [5, 6, 7, 8, 9] of Int64
    answer = Amplifier.max_thruster_loop(commands, phases)
    puts "Part 2 Answer: #{answer}"
  when 8
    puts "--- Day 8: Space Image Format ---"
    puts "On that layer, what is the number of 1 digits multiplied by the number of 2 digits?"
    input = [] of String
    STDIN.each_line do |line|
      input << line
    end

    network_image = NetworkImage.new(25_i64, 6_i64, input[0])
    answer = network_image.image_seed
    puts "Part 1 Answer: #{answer}"
    l = network_image.compute_layer
    puts "Part 2 Answer:"
    l.print
  when 9
    puts "--- Day 9: Sensor Boost ---"
    puts "What BOOST keycode does it produce?"
    commands = [] of Int64
    STDIN.each_line do |line|
      commands = line.split(",").map { |a| a.to_i64 }
    end

    answer = Boost.get_keycode(commands.dup, 1)
    puts "part 1 Answer: #{answer} == 2453265701"

    computer = Boost.new(commands.dup, [2] of Int64)
    computer.perform
    answer = computer.output[0]
    puts "Part 2 Answer: #{answer}"
  when 10
    puts "--- Day 10: Monitoring Station ---"
    puts "How many other asteroids can be detected from that location?"
    commands = [] of String
    STDIN.each_line do |line|
      commands << line
    end

    map = AsteroidMap.new(commands.dup)
    # answer = map.suggestion[0]
    # puts "Part 1 Answer: #{answer} == 274"

    answer = map.vaporized_in(200)
    puts "what do you get if you multiply its X coordinate by 100 and then add its Y"
    puts "Part 2 Answer: #{answer} == 305"
  when 11
    puts "--- Day 11: Space Police ---"
    puts "How many panels does it paint at least once?"
    commands = [] of Int64
    STDIN.each_line do |line|
      commands = line.split(",").map { |a| a.to_i64 }
    end

    computer = Boost.new(commands.dup)
    panels = Panels.new(computer)
    panels.paint
    answer = panels.painted.size
    puts "Part 1 Answer: #{answer} == 1985"

    computer = Boost.new(commands.dup)
    panels = Panels.new(computer, 1)
    panels.paint
    puts "Part 2 Answer: BLCZCJLZ"
    panels.print
  when 12
    puts "--- Day 12: The N-Body Problem ---"
    puts "What is the total energy in the system after simulating the moons given in your scan for 1000 steps?"
    moons = [] of Moon
    STDIN.each_line do |line|
      moons << Moon.parse line
    end

    # answer = Moon.total_energy_after(moons, 1000)
    # puts "Part 1 Answer: #{answer} == 7077"

    big_answer = Moon.steps_of_cycle(moons)
    puts "How many steps does it take to reach the first state that exactly matches a previous state?"
    puts "Part 2 Answer: #{big_answer} == 402951477454512"
  when 13
    puts "--- Day 13: Care Package ---"
    puts "How many block tiles are on the screen when the game exits?"
    commands = [] of Int64
    STDIN.each_line do |line|
      commands = line.split(",").map { |a| a.to_i64 }
    end

    # computer = GameProcessor.new(commands.dup)
    # game = ArcadeGame.new(computer)
    # game.build
    # answer = game.block_titles.size
    # puts "Part 1 Answer: #{answer} == 242"

    mem = commands.dup
    mem[0] = 2
    computer = GameProcessor.new(mem)
    game = ArcadeGame.new(computer)
    game.build
    answer = game.score
    puts "Part 2 Answer: #{answer} == 11641"
  else
    raise "Day should be from 1 to 25"
  end
end

run()
