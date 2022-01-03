# https://adventofcode.com/2021/day/24
#
# --- Day 24: Arithmetic Logic Unit ---
#
# Magic smoke starts leaking from the submarine's arithmetic logic unit (ALU). Without the ability to perform basic arithmetic and logic functions, the submarine can't produce cool patterns with its Christmas lights!
#
# It also can't navigate. Or run the oxygen system.
#
# Don't worry, though - you probably have enough oxygen left to give you enough time to build a new ALU.
#
# The ALU is a four-dimensional processing unit: it has integer variables w, x, y, and z. These variables all start with the value 0. The ALU also supports six instructions:
#
#     inp a - Read an input value and write it to variable a.
#     add a b - Add the value of a to the value of b, then store the result in variable a.
#     mul a b - Multiply the value of a by the value of b, then store the result in variable a.
#     div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
#     mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
#     eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
#
# In all of these instructions, a and b are placeholders; a will always be the variable where the result of the operation is stored (one of w, x, y, or z), while b can be either a variable or a number. Numbers can be positive or negative, but will always be integers.
#
# The ALU has no jump instructions; in an ALU program, every instruction is run exactly once in order from top to bottom. The program halts after the last instruction has finished executing.
#
# (Program authors should be especially cautious; attempting to execute div with b=0 or attempting to execute mod with a<0 or b<=0 will cause the program to crash and might even damage the ALU. These operations are never intended in any serious ALU program.)
#
# For example, here is an ALU program which takes an input number, negates it, and stores it in x:
#
# inp x
# mul x -1
#
# Here is an ALU program which takes two input numbers, then sets z to 1 if the second input number is three times larger than the first input number, or sets z to 0 otherwise:
#
# inp z
# inp x
# mul z 3
# eql z x
#
# Here is an ALU program which takes a non-negative integer as input, converts it into binary, and stores the lowest (1's) bit in z, the second-lowest (2's) bit in y, the third-lowest (4's) bit in x, and the fourth-lowest (8's) bit in w:
#
# inp w
# add z w
# mod z 2
# div w 2
# add y w
# mod y 2
# div w 2
# add x w
# mod x 2
# div w 2
# mod w 2
#
# Once you have built a replacement ALU, you can install it in the submarine, which will immediately resume what it was doing when the ALU failed: validating the submarine's model number. To do this, the ALU will run the MOdel Number Automatic Detector program (MONAD, your puzzle input).
#
# Submarine model numbers are always fourteen-digit numbers consisting only of digits 1 through 9. The digit 0 cannot appear in a model number.
#
# When MONAD checks a hypothetical fourteen-digit model number, it uses fourteen separate inp instructions, each expecting a single digit of the model number in order of most to least significant. (So, to check the model number 13579246899999, you would give 1 to the first inp instruction, 3 to the second inp instruction, 5 to the third inp instruction, and so on.) This means that when operating MONAD, each input instruction should only ever be given an integer value of at least 1 and at most 9.
#
# Then, after MONAD has finished running all of its instructions, it will indicate that the model number was valid by leaving a 0 in variable z. However, if the model number was invalid, it will leave some other non-zero value in z.
#
# MONAD imposes additional, mysterious restrictions on model numbers, and legend says the last copy of the MONAD documentation was eaten by a tanuki. You'll need to figure out what MONAD does some other way.
#
# To enable as many submarine features as possible, find the largest valid fourteen-digit model number that contains no 0 digits. What is the largest model number accepted by MONAD?

class ALU
  property memory : Array(Int64)
  property instructions : Array(Tuple(String, String, String))
  property error : String?
  getter memory_calc : Hash(Char, Array(String))

  def initialize(@instructions)
    @memory = [0, 0, 0, 0] of Int64
    @memory_calc = Hash(Char, Array(String)).new
    @input_point = 0
    @instruction_pointer = 0
    @error = nil
    @cache = Hash(String, Tuple(Int32, Int32, Array(Int64))).new
    @cache_formula = Hash(String, Tuple(Int32, Array(Int64))).new
  end

  def error(msg)
    @error = msg
  end

  def formula
    puts "> formula"
    @memory_calc = {
      'x' => ["0"] of String,
      'y' => ["0"] of String,
      'z' => ["0"] of String,
    }
    w = -1
    @instructions.each do |ins|
      # p ins
      cmd, a, b = ins

      if cmd == "inp"
        w += 1

        # break if w > 4
        # puts "w: w#{w}"

        # @memory_calc.each do |k, w|
        #   puts "#{k}: #{w.join(" ")}"
        # end

        next
      end

      char = a[0]
      # puts "#{a}: #{@memory_calc[char]}"

      if cmd == "add" && @memory_calc[char][-1] == "0"
        # puts "compress add pre"
        @memory_calc[char].pop
        cmd = ""
      elsif cmd == "mul" && @memory_calc[char][-1] == "0"
        # puts "compress mul by 0 pre"
        @memory_calc[char] = ["0"]
        cmd = ""
        next
      elsif cmd == "mul" && @memory_calc[char][-1] == "1"
        # puts "compress mul by 1 pre"
        @memory_calc[char].pop
        cmd = ""
      end

      if b == "w"
        @memory_calc[char] << "w#{w}"
      elsif b[0] > 'w'
        @memory_calc[char] += @memory_calc[b[0]]
      else
        @memory_calc[char] << b
      end

      if cmd.empty?
      elsif cmd == "mul" && @memory_calc[char][-1] == "0"
        # puts "multiply last 0"
        @memory_calc[char] = ["0"]
      elsif cmd == "mul" && @memory_calc[char][-1] == "1"
        # puts "multiply last 1"
        @memory_calc[char].pop
      elsif @memory_calc[char][-1][0] < 'a' && @memory_calc[char][-2][0] < 'a'
        case cmd
        when "add"
          # puts "compress add : #{@memory_calc[char][-2..-1]}"
          add1 = @memory_calc[char].pop.to_i64
          add2 = @memory_calc[char].pop.to_i64
          @memory_calc[char] << (add1 + add2).to_s
        when "div"
          # puts "compress div : #{@memory_calc[char][-2..-1]}"
          add1 = @memory_calc[char].pop.to_i64
          add2 = @memory_calc[char].pop.to_i64
          @memory_calc[char] << (add2 / add1).to_i64.to_s
        when "mod"
          # puts "compress mod : #{@memory_calc[char][-2..-1]}"
          add1 = @memory_calc[char].pop.to_i64
          add2 = @memory_calc[char].pop.to_i64
          @memory_calc[char] << (add2 % add1).to_s
        when "eql"
          # puts "compress eql : #{@memory_calc[char][-2..-1]}"
          add1 = @memory_calc[char].pop.to_i64
          add2 = @memory_calc[char].pop.to_i64
          @memory_calc[char] << (add1 == add2 ? "1" : "0")
        when "mul"
          # puts "compress mul : #{@memory_calc[char][-2..-1]}"
          add1 = @memory_calc[char].pop.to_i64
          add2 = @memory_calc[char].pop.to_i64
          @memory_calc[char] << (add1 * add2).to_s
        else
          @memory_calc[char] << cmd
        end
      elsif cmd == "mul" && (@memory_calc[char][-2] == "0" && @memory_calc[char][-1][0] == 'w')
        # puts "multiply zero variable #{@memory_calc[char][-2..-1]}"
        @memory_calc[char] = ["0"]
      elsif cmd == "add" && (@memory_calc[char][-2] == "0" && @memory_calc[char][-1][0] == 'w')
        add1 = @memory_calc[char].pop
        add2 = @memory_calc[char].pop
        @memory_calc[char] << add1
      elsif cmd == "add" && @memory_calc[char][-1] == "0"
        @memory_calc[char].pop
      elsif cmd == "eql" && b == "w" && @memory_calc[char][-2][0] < 'a' && @memory_calc[char][-2].to_i64 > 9
        # puts "compress eql : #{@memory_calc[char][-2..-1]}"
        @memory_calc[char].pop
        @memory_calc[char].pop
        @memory_calc[char] << "0"
      elsif !cmd.empty?
        @memory_calc[char] << cmd
      end

      # puts "#{a}: #{@memory_calc[char]}"
    end
  end

  def process(input : Array(Int64))
    instruction = @instructions[@instruction_pointer]
    # puts "-"*100
    # puts "ip: #{@instruction_pointer}"
    # puts "instruction: #{instruction}"
    # puts "memory: #{@memory}"

    i = input.size - 1
    while i > @input_point
      key = input[..i].to_s
      if @cache.has_key?(key)
        old = @instruction_pointer
        @instruction_pointer, @input_point, @memory = @cache[key]
        @memory = @memory.dup
        # puts "  hit cache #{key}: #{old} ip -> #{@instruction_pointer} ip, #{@input_point}, #{@memory}"
        return if @instruction_pointer >= @instructions.size
        instruction = @instructions[@instruction_pointer]
        # puts "  ip: #{@instruction_pointer}"
        # puts "  instruction: #{instruction}"
        # puts "  memory: #{@memory}"
        break
      end
      i -= 1
    end

    cmd, a, b = instruction
    case cmd
    when "inp"
      write(a, input[@input_point])
      @input_point += 1
    when "mul"
      ac = val(a) * val(b)
      write(a, ac)
    when "add"
      ac = val(a) + val(b)
      write(a, ac)
    when "mod"
      av = val(a)
      bv = val(b)
      return error("mod with zeros") if av < 0 && bv <= 0
      ac = val(a) % val(b)
      write(a, ac)
    when "div"
      bv = val(b)
      return error("div on zero") if bv == 0
      ac = val(a) / bv
      write(a, ac.to_i64)
    when "eql"
      ac = val(a) == val(b) ? 1_i64 : 0_i64
      write(a, ac)
    else
      raise "#{cmd} is not implemented"
    end
    @instruction_pointer += 1

    cache_key = input[...@input_point].to_s
    @cache[cache_key] = {@instruction_pointer, @input_point, @memory.dup}
    # puts "after memory: #{@memory}"
  end

  def val(arg)
    return arg.to_i64 if arg.size > 1 || arg[0] < 'w' || arg[0] > 'z'
    return read(arg)
  end

  def read(arg)
    addr = arg[0] - 'w'
    return @memory[addr]
  end

  def write(arg, val)
    addr = arg[0] - 'w'
    @memory[addr] = val
  end

  def run(input : Array(Int64))
    @memory = [0, 0, 0, 0] of Int64
    @input_point = 0
    @instruction_pointer = 0
    @error = nil
    n = @instructions.size
    while @instruction_pointer < n
      process(input)
      return if !error.nil?
    end
    # puts "#{instruction}: #{@memory}"
  end

  def validate(input : Array(Int64))
    run(input)
    return false if !error.nil?
    return @memory[3] == 0
  end

  def min(num : Array(Int64) = [] of Int64)
    # puts "> min: #{num}"
    return if num.size >= 15
    if num.size == 14
      return num.map(&.to_s).join.to_i64 if validate(num)
      return nil
    end

    9_i64.downto(1_i64) do |i|
      n = min(num + [i.dup])
      return n if !n.nil?
      break if i < 9
    end

    nil
  end

  def validate_formula(num : Array(Int64) = [] of Int64)
    # puts "> validate_formula"
    raise "num.size: #{num.size} != 14" if num.size != 14
    stack = Array(Int64).new
    max_input_pointer = 0
    instructions = @memory_calc['z']
    instruction_pointer = 0

    i = num.size - 1
    while i >= 0
      cache_key = num[..i].to_s
      if @cache_formula.has_key?(cache_key)
        instruction_pointer, stack = @cache_formula[cache_key]
        max_input_pointer = i
        break
      end
      i -= 1
    end

    i = instruction_pointer
    instructions[instruction_pointer..].each do |el|
      case el
      when "add"
        a = stack.pop + stack.pop
        stack << a
      when "div"
        b = stack.pop
        a = stack.pop
        stack << (a / b).to_i64
      when "mod"
        b = stack.pop
        a = stack.pop
        stack << (a % b)
      when "mul"
        b = stack.pop
        a = stack.pop
        stack << b * a
      when "eql"
        b = stack.pop
        a = stack.pop
        stack << (b == a ? 1_i64 : 0_i64)
      else
        if el[0] == 'w'
          input_pointer = el[1..].to_i
          max_input_pointer = input_pointer if max_input_pointer < input_pointer
          stack << num[el[1..].to_i]
        else
          stack << el.to_i64
        end
      end
      i += 1

      cache_key = num[..max_input_pointer].to_s
      @cache_formula[cache_key] = {i, stack}
    end
    raise "wrong algorithm" if stack.size != 1
    stack.last
  end
end

def problem24(records : Array(String))
  input = [] of Tuple(String, String, String)
  records.each do |line|
    next if line.empty?
    cmd, args = line.split(" ", 2)
    a, b = "", ""
    s = args.split(" ", 2)
    if s.size == 1
      a = s[0]
    else
      a, b = s
    end
    input << {cmd, a, b}
  end

  # channel = Channel(Int64).new
  # 9_i64.downto(1_i64) do |i|
  #   spawn do
  #     num : Array(Int64) = [i]
  alu = ALU.new(input)
  alu.optimize
  # alu.formula

  # puts "z: #{alu.memory_calc['z'].size}"
  # puts alu.memory_calc['z'].join(" ")

  # 9_i64.downto(1_i64) do |el|
  #   puts alu.validate_formula([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, el] of Int64)
  # end

  # alu.min([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] of Int64)
  # puts alu.memory.last

  return alu.min

  #   global = Array(Hash(Int32, Array(Int64))).new
  #
  #   1_i64.upto(9_i64) do |default|
  #     results = Hash(Int32, Array(Int64)).new
  #     14.times do |indx|
  #       results[indx] = Array(Int64).new
  #       1_i64.upto(9_i64) do |i|
  #         num = Array(Int64).new(14, default)
  #         num[indx] = i
  #         # num[2] = 1
  #         alu.min(num)
  #         a = alu.memory.last
  #         results[indx] << a
  #         puts "done: #{a}\n----------------------\n\n"
  #       end
  #     end
  #     global << results
  #   end
  #
  #   puts "results:"
  #   global.each_with_index do |results, i|
  #     puts "default: #{i + 1}"
  #     results.each do |k, v|
  #       puts "%2d: #{v.join("\t")}" % k
  #     end
  #     puts "-=-=-="*10
  #   end
  #   n = alu.min(num)
  #   channel.send(n) if !n.nil?
  # end
  # end

  # p channel.receive
end
