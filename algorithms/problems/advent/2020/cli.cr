require "option_parser"
require "./day_one"
require "./day_two"
require "./day_three"
require "./day_four"
require "./day_five"
require "./day7"
require "./day8"
require "./day9"

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
  when 2.1
    puts "--- Day 2: Password Philosophy ---"
    puts "--- Part One ---"
    puts "How many passwords are valid according to their policies?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = Password.parse(entries).count { |pass| pass.valid? }
    puts "Answer: #{answer}"
  when 2.2
    puts "--- Day 2: Password Philosophy ---"
    puts "--- Part Two ---"
    puts "How many passwords are valid according to the new interpretation of the policies?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = Password.parse(entries).count { |pass| pass.valid?(2) }
    puts "Answer: #{answer}"
  when 3.1
    puts "--- Day 3: Toboggan Trajectory ---"
    puts "--- Part One ---"
    puts "Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    answer = TobogganTrajectory.new(entries).traversing(3, 1).count('#')
    puts "Answer: #{answer}"
  when 3.2
    puts "--- Day 3: Toboggan Trajectory ---"
    puts "--- Part Two ---"
    puts "What do you get if you multiply together the number of trees encountered on each of the listed slopes?"
    entries = [] of String
    STDIN.each_line do |line|
      entries << line
    end

    trees = [] of Int64
    [
      {1.to_i64, 1.to_i64},
      {3.to_i64, 1.to_i64},
      {5.to_i64, 1.to_i64},
      {7.to_i64, 1.to_i64},
      {1.to_i64, 2.to_i64},
    ].each do |step|
      trees << TobogganTrajectory.new(entries).traversing(step[0], step[1]).count('#').to_i64
    end
    answer = trees.reduce(1.to_i64) { |a, i| a * i }
    puts "Answer: #{answer}"
  when 4.1
    puts "--- Day 4: Passport Processing ---"
    puts "--- Part One ---"
    puts "In your batch file, how many passports are valid?"
    entries = [] of Passport
    buf = ""
    STDIN.each_line do |line|
      if line.size == 0
        entries << Passport.parse(buf)
        buf = ""
      else
        buf += " " + line
      end
    end

    if buf.size != 0
      entries << Passport.parse(buf)
    end

    entries.select! do |pass|
      pass.has_required_fields?
    end

    answer = entries.size
    puts "Answer: #{answer}"
  when 4.2
    puts "--- Day 4: Passport Processing ---"
    puts "--- Part Two ---"
    puts "In your batch file, how many passports are valid?"
    entries = [] of Passport
    buf = ""
    STDIN.each_line do |line|
      if line.size == 0
        entries << Passport.parse(buf)
        buf = ""
      else
        buf += " " + line
      end
    end

    if buf.size != 0
      entries << Passport.parse(buf)
    end

    entries.select! do |pass|
      pass.valid?
    end

    answer = entries.size
    puts "Answer: #{answer}"
  when 5.1
    puts "--- Day 5: Binary Boarding ---"
    puts "--- Part One ---"
    puts "What is the highest seat ID on a boarding pass?"
    entries = [] of Int64

    STDIN.each_line do |line|
      entries << BoardSeat.parse(line).seat_id
    end

    answer = entries.max
    puts "Answer: #{answer}"
  when 5.2
    puts "--- Day 5: Binary Boarding ---"
    puts "--- Part Two ---"
    puts "What is the ID of your seat?"
    entries = [] of Int64

    STDIN.each_line do |line|
      entries << BoardSeat.parse(line).seat_id
    end

    entries.sort!
    i = 0
    prev = entries[0]
    answer = prev
    while i < entries.size
      i += 1
      cur = entries[i]
      if cur - prev > 1
        answer = cur - 1
        break
      end
      prev = cur
    end

    puts "Answer: #{answer}"
  when 6.1
    puts "--- Day 6: Custom Customs ---"
    puts "--- Part One ---"
    puts "What is the sum of those counts?"
    answer = 0
    buf = ""
    STDIN.each_line do |line|
      if line.size == 0
        answer += buf.chars.uniq.size
        buf = ""
      else
        buf += line
      end
    end
    if buf.size != 0
      answer += buf.chars.uniq.size
    end
    puts "Answer: #{answer}"
  when 6.2
    puts "--- Day 6: Custom Customs ---"
    puts "--- Part Two ---"
    puts "What is the sum of those counts?"
    answer = 0
    entries = [] of String
    buf = ""
    STDIN.each_line do |line|
      if line.size == 0
        answer += buf.strip.split(" ").map { |a| a.chars.sort.uniq }.reduce { |a, i| a & i }.size
        buf = ""
      else
        buf += " " + line
      end
    end
    if buf.size != 0
      answer += buf.strip.split(" ").map { |a| a.chars.sort.uniq }.reduce { |a, i| a & i }.size
    end
    puts "Answer: #{answer}"
  when 7.1
    puts "--- Day 7: Handy Haversacks ---"
    puts "--- Part One ---"
    puts "How many bag colors can eventually contain at least one shiny gold bag? "
    answer = 0
    bags = Hash(String, Array(String)).new
    reverse_bags = Hash(String, Array(String)).new
    STDIN.each_line do |line|
      bag = line.gsub(" contain no other bags.", "")
        .gsub("bags", "bag").gsub("contain", "")
        .gsub("  ", " ")
        .gsub(".", "")
        .gsub(",", "").split(" bag")
      clean_bags = Array(String).new
      bag[1..-2].each do |b|
        clean_bag = b.gsub(/^ \d* /, "")
        clean_bags << clean_bag
        reverse_bags[clean_bag] ||= Array(String).new
        reverse_bags[clean_bag] << bag[0]
      end
      bags[bag[0]] = clean_bags
    end

    bags_with_shiny_gold = Hash(String, Bool).new

    queue = reverse_bags["shiny gold"]
    bags_with_shiny_gold["shiny gold"] = true
    while queue.size > 0
      new_queue = Array(String).new
      queue.each do |with_gold_bag|
        bags_with_shiny_gold[with_gold_bag] = true
        new_queue += reverse_bags[with_gold_bag] if reverse_bags.has_key?(with_gold_bag)
      end
      queue = new_queue
    end

    answer = 0
    bags.keys.each do |bag|
      if bags_with_shiny_gold.has_key?(bag) && bag != "shiny gold"
        answer += 1
      end
    end

    puts "Answer: #{answer}"
  when 7.2
    puts "--- Day 7: Handy Haversacks ---"
    puts "--- Part Two ---"
    puts "How many individual bags are required inside your single shiny gold bag?"
    answer = 0
    bags = Hash(String, Array(String)).new
    STDIN.each_line do |line|
      bag = line.gsub(" contain no other bags.", "")
        .gsub("bags", "bag").gsub("contain", "")
        .gsub("  ", " ")
        .gsub(".", "")
        .gsub(",", "").split(" bag")
      bags[bag[0]] = bag[1..-2]
    end

    answer = count_bags("shiny gold", bags)
    puts "Answer: #{answer}"
  when 8.1
    puts "--- Day 8: Handheld Halting ---"
    puts "--- Part One ---"
    puts "what value is in the accumulator?"
    code = [] of GameboyCommand

    STDIN.each_line do |line|
      code << GameboyCommand.parse(line)
    end

    console = Gameboy.new(code)
    console.detect_loop
    answer = console.accumulator
    puts "Answer: #{answer}"
  when 8.2
    puts "--- Day 8: Handheld Halting ---"
    puts "--- Part Two ---"
    puts "What is the value of the accumulator after the program terminates?"
    code = [] of GameboyCommand

    STDIN.each_line do |line|
      code << GameboyCommand.parse(line)
    end

    answer = 0.to_i64
    console = Gameboy.new(code)
    history = console.detect_loop
    steps = 0
    history.reverse.each do |cmd_id|
      steps += 1
      new_code = code.dup
      new_code[cmd_id] = new_code[cmd_id].swap
      console = Gameboy.new(new_code)
      console.detect_loop
      if console.end?
        answer = console.accumulator
        break
      end
    end

    puts "Answer: #{answer}"
    puts "(detected in #{steps} steps)"
  when 9.1
    puts "--- Day 8: Handheld Halting ---"
    puts "--- Part One ---"
    puts "what value is in the accumulator?"
    input = [] of Int64

    STDIN.each_line do |line|
      input << line.to_i64
    end

    answer = weak_number(input, 25.to_i64)
    puts "Answer: #{answer}"
  when 9.2
    puts "--- Day 8: Handheld Halting ---"
    puts "--- Part One ---"
    puts "what value is in the accumulator?"
    input = [] of Int64

    STDIN.each_line do |line|
      input << line.to_i64
    end

    n = weak_number_index(input, 25.to_i64)
    if n.nil?
      puts "Could not find index woth weak number in array"
      return
    end
    broken = input[n]
    answer = hash_largest_contiguous_numbers(input[0..n], broken.not_nil!)

    # n = i + num
    # subset = input[0..n]
    # while n > 0
    #   result = find_contiguous_entries_to_sum(subset, n.to_i64, weak_number.not_nil!)
    #   if !result.empty?
    #     answer = result[0] + result[-1]
    #     break
    #   end
    #   n -= 1
    # end

    puts "Answer: #{answer}"
  else
    raise "Day is not implemented"
  end
end

elapsed_time = Time.measure do
  run()
end
puts "(execute time: #{elapsed_time})"
