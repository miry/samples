# https://adventofcode.com/2019/day/9
#
# --- Day 9: Sensor Boost ---
#
# You've just said goodbye to the rebooted rover and left Mars when you receive a faint distress signal coming from the asteroid belt. It must be the Ceres monitoring station!
#
# In order to lock on to the signal, you'll need to boost your sensors. The Elves send up the latest BOOST program - Basic Operation Of System Test.
#
# While BOOST (your puzzle input) is capable of boosting your sensors, for tenuous safety reasons, it refuses to do so until the computer it runs on passes some checks to demonstrate it is a complete Intcode computer.
#
# Your existing Intcode computer is missing one key feature: it needs support for parameters in relative mode.
#
# Parameters in mode 2, relative mode, behave very similarly to parameters in position mode: the parameter is interpreted as a position. Like position mode, parameters in relative mode can be read from or written to.
#
# The important difference is that relative mode parameters don't count from address 0. Instead, they count from a value called the relative base. The relative base starts at 0.
#
# The address a relative mode parameter refers to is itself plus the current relative base. When the relative base is 0, relative mode parameters and position mode parameters with the same value refer to the same address.
#
# For example, given a relative base of 50, a relative mode parameter of -7 refers to memory address 50 + -7 = 43.
#
# The relative base is modified with the relative base offset instruction:
#
#     Opcode 9 adjusts the relative base by the value of its only parameter. The relative base increases (or decreases, if the value is negative) by the value of the parameter.
#
# For example, if the relative base is 2000, then after the instruction 109,19, the relative base would be 2019. If the next instruction were 204,-34, then the value at address 1985 would be output.
#
# Your Intcode computer will also need a few other capabilities:
#
#     The computer's available memory should be much larger than the initial program. Memory beyond the initial program starts with the value 0 and can be read or written like any other memory. (It is invalid to try to access memory at a negative address, though.)
#     The computer should have support for large numbers. Some instructions near the beginning of the BOOST program will verify this capability.
#
# Here are some example programs that use these features:
#
#     109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99 takes no input and produces a copy of itself as output.
#     1102,34915192,34915192,7,4,7,99,0 should output a 16-digit number.
#     104,1125899906842624,99 should output the large number in the middle.
#
# The BOOST program will ask for a single input; run it in test mode by providing it the value 1. It will perform a series of checks on each opcode, output any opcodes (and the associated parameter modes) that seem to be functioning incorrectly, and finally output a BOOST keycode.
#
# Once your Intcode computer is fully functional, the BOOST program should report no malfunctioning opcodes when run in test mode; it should only output a single value, the BOOST keycode. What BOOST keycode does it produce?

class Boost
  class Halt < Exception
  end

  POSITION_MODE  = 0
  IMMEDIATE_MODE = 1
  RELATIVE_MODE  = 2

  SUM_CODE                  =  1
  MUL_CODE                  =  2
  INPUT_CODE                =  3
  OUTPUT_CODE               =  4
  JUMP_IF_TRUE_CODE         =  5 # if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
  JUMP_IF_FALSE_CODE        =  6 # if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
  LESS_THAN_CODE            =  7 # if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  EQUALS_CODE               =  8 # if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  ADJUST_RELATIVE_BASE_CODE =  9
  EXIT_CODE                 = 99

  @ipc : Int64
  getter state : Array(Int64)
  getter output : Array(Int64)
  getter input : Array(Int64)

  def initialize(@state : Array(Int64), @input : Array(Int64) = [] of Int64)
    @output = [] of Int64
    @stop_on_output = false
    @ipc = 0_i64
    @relative_base = 0
  end

  def self.amplifiers(state : Array(Int64), phases : Array(Int64), input = 0_i64)
    prev = input
    phases.each do |phase|
      applifier = self.new(state, [phase, prev] of Int64)
      applifier.perform
      prev = applifier.output[-1]
    end
    prev
  end

  def self.amplifiers_loop(state : Array(Int64), phases : Array(Int64), input : Int64 = 0_i64)
    computers : Array(Boost) = Array.new(phases.size) { |i| Boost.new(state.dup, [phases[i]] of Int64) }
    prev = input
    while true
      computers.each_with_index do |amplifier, i|
        # puts "Process applifier #{i}"
        # puts "  state: #{state}"
        amplifier.input << prev
        begin
          amplifier.perform
          prev = amplifier.output.delete_at(0)
        rescue Boost::Halt
          return prev
        end
      end
    end
    return prev.not_nil!
  end

  def self.max_thruster(state : Array(Int64), phases : Array(Int64))
    max = 0_i64
    phases.each_permutation do |variant|
      thruster : Int64 = self.amplifiers state, variant
      max = thruster if max < thruster
    end
    max
  end

  def self.max_thruster_loop(state : Array(Int64), phases : Array(Int64))
    max = 0_i64
    phases.each_permutation do |variant|
      thruster : Int64 = self.amplifiers_loop state, variant
      max = thruster if max < thruster
    end
    max
  end

  def run
    while true
      perform
    end
  rescue Boost::Halt
    return
  end

  def perform
    n = @state.size
    while @ipc < n
      command = normalize(@state[@ipc])

      # p "-- @ipc: #{@ipc} ; @relative_base: #{@relative_base} ; code: #{command}"
      # p @state[@ipc..@ipc + 4]
      # p @state

      raise "Could not normalize instruction #{@state[@ipc]}" if command.nil?
      case command[0]
      when MUL_CODE
        addendum1, addendum2, result = values(@ipc, command)
        @ipc += 4
        set(result, addendum1 * addendum2)
      when SUM_CODE
        addendum1, addendum2, result = values(@ipc, command)
        @ipc += 4
        set(result, addendum1 + addendum2)
      when INPUT_CODE
        addr = @state[@ipc + 1]
        addr = addr_by(addr, command[1])
        # puts "Input of @ipc #{@ipc} with addr #{addr} from #{input}"
        if input.size == 0
          # puts "Stop until provide input"
          return
        end
        set(addr, @input.delete_at(0))
        @ipc += 2
      when OUTPUT_CODE
        @ipc += 1
        addr = get(@ipc)
        addr = value_by(addr, command[1])

        # puts "Output of @ipc #{@ipc} with addr #{addr} with value #{addr}"
        # puts " state: #{@state}"

        @output << addr
        @ipc += 1
        # return
      when JUMP_IF_TRUE_CODE
        addendum1 = @state[@ipc + 1]
        addendum1 = value_by(addendum1, command[1])

        next_ipc = @state[@ipc + 2]
        next_ipc = value_by(next_ipc, command[2])

        if addendum1 == 0
          @ipc += 3
        else
          @ipc = next_ipc
        end
      when JUMP_IF_FALSE_CODE
        addendum1 = @state[@ipc + 1]
        addendum1 = value_by(addendum1, command[1])
        next_ipc = @state[@ipc + 2]
        next_ipc = value_by(next_ipc, command[2])

        if addendum1 != 0
          @ipc += 3
        else
          @ipc = next_ipc
        end
      when LESS_THAN_CODE
        addendum1, addendum2, result = values(@ipc, command)
        @ipc += 4
        set(result, addendum1 < addendum2 ? 1_i64 : 0_i64)
      when EQUALS_CODE
        addendum1, addendum2, result = values(@ipc, command)
        @ipc += 4
        set(result, addendum1 == addendum2 ? 1_i64 : 0_i64)
      when ADJUST_RELATIVE_BASE_CODE
        @ipc += 1
        value = @state[@ipc]
        value = value_by(value, command[1])
        @relative_base += value
        # p "-- modified relative base: #{@relative_base}"
        @ipc += 1
      when EXIT_CODE
        # puts "Halt!!!"
        raise Halt.new("Finish process on step #{@ipc}")
      else
        raise("Unknown code #{command[0]}")
      end
    end
  end

  def normalize(instruction)
    digits = to_digits(instruction)
    n = digits.size
    (5 - n).times do
      digits.insert(0, 0_i32)
    end
    result = [0, digits[2], digits[1], digits[0]] of Int32
    result[0] = digits[3]*10 + digits[4]
    result
  end

  def sum(addendum1, addendum2, result)
    @state[result] = @state[addendum1] + @state[addendum2]
  end

  def mul(addendum1, addendum2, result)
    @state[result] = @state[addendum1] * @state[addendum2]
  end

  def self.detect_inputs(state : Array(Int64), expected : Int64)
    100_i64.times do |noun|
      state[1] = noun
      100_i64.times do |verb|
        state[2] = verb
        computer = Computer.new(state.dup)
        computer.perform
        return noun * 100 + verb if 19690720 == computer.state[0]
      end
    end
  end

  def to_digits(number : Int)
    result = Array(Int32).new(6)
    div = number
    while div >= 10
      div, mod = div.divmod(10)
      result.insert(0, mod.to_i32)
    end
    result.insert(0, div.to_i32)
    result
  end

  def values(@ipc, params)
    addendum1, addendum2, result = @state[@ipc + 1..@ipc + 4]
    addendum1 = value_by(addendum1, params[1])
    addendum2 = value_by(addendum2, params[2])
    result += @relative_base if params[3] == RELATIVE_MODE
    return {addendum1, addendum2, result}
  end

  def value_by(addr, mode)
    case mode
    when RELATIVE_MODE
      addr += @relative_base
      get(addr)
    when POSITION_MODE
      get(addr)
    when IMMEDIATE_MODE
      addr
    else
      raise "Unknow mode #{mode}"
    end
  end

  def addr_by(addr, mode)
    case mode
    when RELATIVE_MODE
      addr += @relative_base
      addr
    when POSITION_MODE
      addr
    when IMMEDIATE_MODE
      addr
    else
      raise "Unknow mode #{mode}"
    end
  end

  def get(addr)
    raise "Access to negative address: #{addr}" if addr < 0
    increase_memory(addr) if @state.size <= addr
    @state[addr]
  end

  def set(addr, val)
    old = get(addr)
    @state[addr] = val
    # p "---> modified: @ipc #{addr} from #{old} to #{val}"
  end

  def increase_memory(addr)
    @state = @state + Array(Int64).new(addr - @state.size + 1) { 0_i64 }
  end

  def self.get_keycode(state : Array(Int64), input : Int64)
    computer = Boost.new state, [input] of Int64

    while true
      computer.perform
      # p computer.output
    end
  end
end
