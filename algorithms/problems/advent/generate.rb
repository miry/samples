require "date"

# Create a dummy `day*.cr`` and `day*_spec.cr` files.
# Print the basic switch case for the `cli.cr`.
def generate(day)
  File.open("day#{day}.cr", "w") do |f|
    f.puts (<<~EOS)
      # https://adventofcode.com/#{Date.today.year}/day/#{day}
      #
      # --- Day #{day}: ... ---
      #

      def problem#{day}(records : Array(Int64))
        raise "not implemented"
      end

      # --- Part Two ---

      def problem#{day}_part_two(records : Array(Int64))
        raise "not implemented"
      end
    EOS
  end

  File.open("day#{day}_spec.cr", "w") do |f|
    f.puts (<<~EOS)
      require "spec"
      require "./day#{day}"

      describe "Day #{day}" do
      end
    EOS
  end

  puts <<~EOS
  when #{day}.1
    puts "--- Day #{day}: Sonar Sweep ---"
    puts "--- Part One ---"
    puts "How many measurements are larger than the previous measurement?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = problem#{day}(entries)
  when #{day}.2
    puts "--- Day #{day}: Sonar Sweep ---"
    puts "--- Part Two ---"
    puts "Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?"
    entries = [] of Int64
    STDIN.each_line do |line|
      entries << line.to_i64
    end

    answer = problem#{day}_part_two(entries)
  EOS
end

1.upto(25) do |i|
  puts "require \"./day#{i}\""
end

1.upto(25) do |i|
  generate(i)
end
