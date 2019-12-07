# https://adventofcode.com/2019/day/7
#
# --- Day 7: Amplification Circuit ---
#
# Based on the navigational maps, you're going to need to send more power to your ship's thrusters to reach Santa in time. To do this, you'll need to configure a series of amplifiers already installed on the ship.
#
# There are five amplifiers connected in series; each one receives an input signal and produces an output signal. They are connected such that the first amplifier's output leads to the second amplifier's input, the second amplifier's output leads to the third amplifier's input, and so on. The first amplifier's input value is 0, and the last amplifier's output leads to your ship's thrusters.
#
#     O-------O  O-------O  O-------O  O-------O  O-------O
# 0 ->| Amp A |->| Amp B |->| Amp C |->| Amp D |->| Amp E |-> (to thrusters)
#     O-------O  O-------O  O-------O  O-------O  O-------O
#
# The Elves have sent you some Amplifier Controller Software (your puzzle input), a program that should run on your existing Intcode computer. Each amplifier will need to run a copy of the program.
#
# When a copy of the program starts running on an amplifier, it will first use an input instruction to ask the amplifier for its current phase setting (an integer from 0 to 4). Each phase setting is used exactly once, but the Elves can't remember which amplifier needs which phase setting.
#
# The program will then call another input instruction to get the amplifier's input signal, compute the correct output signal, and supply it back to the amplifier with an output instruction. (If the amplifier has not yet received an input signal, it waits until one arrives.)
#
# Your job is to find the largest output signal that can be sent to the thrusters by trying every possible combination of phase settings on the amplifiers. Make sure that memory is not shared or reused between copies of the program.
#
# For example, suppose you want to try the phase setting sequence 3,1,2,4,0, which would mean setting amplifier A to phase setting 3, amplifier B to setting 1, C to 2, D to 4, and E to 0. Then, you could determine the output signal that gets sent from amplifier E to the thrusters with the following steps:
#
#     Start the copy of the amplifier controller software that will run on amplifier A. At its first input instruction, provide it the amplifier's phase setting, 3. At its second input instruction, provide it the input signal, 0. After some calculations, it will use an output instruction to indicate the amplifier's output signal.
#     Start the software for amplifier B. Provide it the phase setting (1) and then whatever output signal was produced from amplifier A. It will then produce a new output signal destined for amplifier C.
#     Start the software for amplifier C, provide the phase setting (2) and the value from amplifier B, then collect its output signal.
#     Run amplifier D's software, provide the phase setting (4) and input value, and collect its output signal.
#     Run amplifier E's software, provide the phase setting (0) and input value, and collect its output signal.
#
# The final output signal from amplifier E would be sent to the thrusters. However, this phase setting sequence may not have been the best one; another sequence might have sent a higher signal to the thrusters.
#
# Here are some example programs:
#
#     Max thruster signal 43210 (from phase setting sequence 4,3,2,1,0):
#
#     3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0
#
#     Max thruster signal 54321 (from phase setting sequence 0,1,2,3,4):
#
#     3,23,3,24,1002,24,10,24,1002,23,-1,23,
#     101,5,23,23,1,24,23,23,4,23,99,0,0
#
#     Max thruster signal 65210 (from phase setting sequence 1,0,4,3,2):
#
#     3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
#     1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0
#
# Try every combination of phase settings on the amplifiers. What is the highest signal that can be sent to the thrusters?
#
# --- Part Two ---
#
# It's no good - in this configuration, the amplifiers can't generate a large enough output signal to produce the thrust you'll need. The Elves quickly talk you through rewiring the amplifiers into a feedback loop:
#
#       O-------O  O-------O  O-------O  O-------O  O-------O
# 0 -+->| Amp A |->| Amp B |->| Amp C |->| Amp D |->| Amp E |-.
#    |  O-------O  O-------O  O-------O  O-------O  O-------O |
#    |                                                        |
#    '--------------------------------------------------------+
#                                                             |
#                                                             v
#                                                      (to thrusters)
#
# Most of the amplifiers are connected as they were before; amplifier A's output is connected to amplifier B's input, and so on. However, the output from amplifier E is now connected into amplifier A's input. This creates the feedback loop: the signal will be sent through the amplifiers many times.
#
# In feedback loop mode, the amplifiers need totally different phase settings: integers from 5 to 9, again each used exactly once. These settings will cause the Amplifier Controller Software to repeatedly take input and produce output many times before halting. Provide each amplifier its phase setting at its first input instruction; all further input/output instructions are for signals.
#
# Don't restart the Amplifier Controller Software on any amplifier during this process. Each one should continue receiving and sending signals until it halts.
#
# All signals sent or received in this process will be between pairs of amplifiers except the very first signal and the very last signal. To start the process, a 0 signal is sent to amplifier A's input exactly once.
#
# Eventually, the software on the amplifiers will halt after they have processed the final loop. When this happens, the last output signal from amplifier E is sent to the thrusters. Your job is to find the largest output signal that can be sent to the thrusters using the new phase settings and feedback loop arrangement.
#
# Here are some example programs:
#
#     Max thruster signal 139629729 (from phase setting sequence 9,8,7,6,5):
#
#     3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
#     27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
#
#     Max thruster signal 18216 (from phase setting sequence 9,7,8,5,6):
#
#     3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
#     -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
#     53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10
#
# Try every combination of the new phase settings on the amplifier feedback loop. What is the highest signal that can be sent to the thrusters?

class Amplifier
  class Halt < Exception
  end

  EXIT_CODE = 99

  SUM_CODE           = 1
  MUL_CODE           = 2
  INPUT_CODE         = 3
  OUTPUT_CODE        = 4
  JUMP_IF_TRUE_CODE  = 5
  JUMP_IF_FALSE_CODE = 6
  LESS_THAN_CODE     = 7
  EQUALS_CODE        = 8

  @ipc : Int64
  getter state : Array(Int64)
  getter output : Array(Int64)
  getter input : Array(Int64)

  def initialize(@state : Array(Int64), @input : Array(Int64) = [] of Int64)
    @output = [] of Int64
    @stop_on_output = false
    @ipc = 0_i64
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
    computers : Array(Amplifier) = Array.new(phases.size) { |i| Amplifier.new(state.dup, [phases[i]] of Int64) }
    prev = input
    while true
      computers.each_with_index do |amplifier, i|
        # puts "Process applifier #{i}"
        # puts "  state: #{state}"
        amplifier.input << prev
        begin
          amplifier.perform
          prev = amplifier.output.delete_at(0)
        rescue Amplifier::Halt
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

  def perform
    n = @state.size
    while @ipc < n
      command = normalize(@state[@ipc])

      # p "-- @ipc: #{@ipc} code: #{command}"
      # p @state[@ipc..@ipc+4]
      # p @state

      raise "Could not normalize instruction #{@state[@ipc]}" if command.nil?
      case command[0]
      when MUL_CODE
        addendum1, addendum2, result = values(@ipc, command)
        @ipc += 4
        @state[result] = addendum1 * addendum2
        # p "-- modified: #{result}"
      when SUM_CODE
        addendum1, addendum2, result = values(@ipc, command)
        @ipc += 4
        @state[result] = addendum1 + addendum2
        # p "-- modified: #{result}"
      when INPUT_CODE
        addr = @state[@ipc + 1]

        # puts "Input of @ipc #{@ipc} with addr #{addr} from #{input}"
        if input.size == 0
          # puts "Stop until provide input"
          return
        end
        @state[addr] = @input.delete_at(0)

        # p "-- modified: #{addr}"
        @ipc += 2
      when OUTPUT_CODE
        @ipc += 1
        addr = @state[@ipc]
        addr = @state[addr] if command[1] == 0

        # puts "Output of @ipc #{@ipc} with addr #{addr} with value #{addr}"
        # puts " state: #{@state}"

        @output << addr
        @ipc += 1
        return
      when JUMP_IF_TRUE_CODE
        addendum1 = @state[@ipc + 1]
        addendum1 = @state[addendum1] if command[1] == 0
        next_ipc = @state[@ipc + 2]
        next_ipc = @state[next_ipc] if command[2] == 0

        if addendum1 == 0
          @ipc += 3
        else
          @ipc = next_ipc
        end
      when JUMP_IF_FALSE_CODE
        addendum1 = @state[@ipc + 1]
        addendum1 = @state[addendum1] if command[1] == 0
        next_ipc = @state[@ipc + 2]
        next_ipc = @state[next_ipc] if command[2] == 0

        if addendum1 != 0
          @ipc += 3
        else
          @ipc = next_ipc
        end
      when LESS_THAN_CODE
        addendum1, addendum2, result = values(@ipc, command)
        @ipc += 4
        @state[result] = addendum1 < addendum2 ? 1_i64 : 0_i64
      when EQUALS_CODE
        addendum1, addendum2, result = values(@ipc, command)
        @ipc += 4
        @state[result] = addendum1 == addendum2 ? 1_i64 : 0_i64
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
    addendum1 = @state[addendum1] if params[1] == 0
    addendum2 = @state[addendum2] if params[2] == 0
    # result = @state[result] if params[3] == 0
    return {addendum1, addendum2, result}
  end
end
