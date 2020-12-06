require "option_parser"
require "./day_one"
require "./day_two"
require "./day_three"
require "./day_four"
require "./day_five"

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
        answer += buf.strip.split(" ").map {|a| a.chars.sort.uniq }.reduce{|a,i| a & i}.size
        buf = ""
      else
        buf += " " + line
      end
    end
    if buf.size != 0
      answer += buf.strip.split(" ").map {|a| a.chars.sort.uniq }.reduce{|a,i| a & i}.size
    end
    puts "Answer: #{answer}"
  else
    raise "Day is not implemented"
  end
end

elapsed_time = Time.measure do
  run()
end
puts "(execute time: #{elapsed_time})"
