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

class Amplifier
  EXIT_CODE = 99

  SUM_CODE           = 1
  MUL_CODE           = 2
  INPUT_CODE         = 3
  OUTPUT_CODE        = 4
  JUMP_IF_TRUE_CODE  = 5
  JUMP_IF_FALSE_CODE = 6
  LESS_THAN_CODE     = 7
  EQUALS_CODE        = 8

  getter state : Array(Int64)
  getter output : Array(Int64)
  getter input : Array(Int64)

  def initialize(@state : Array(Int64), @input : Array(Int64) = [] of Int64)
    @output = [] of Int64
  end

  def self.applifiers(state : Array(Int64), phases : Array(Int64))
    prev = 0_i64
    phases.each do |phase|
      applifier = self.new(state, [phase, prev] of Int64)
      applifier.perform
      prev = applifier.output[-1]
    end
    prev
  end

  def perform
    ipc = 0
    n = @state.size
    while ipc < n
      command = normalize(@state[ipc])

      # p "-- ipc: #{ipc} code: #{command}"
      # p @state[ipc..ipc+4]
      # p @state

      raise "Could not normalize instruction #{@state[ipc]}" if command.nil?
      case command[0]
      when MUL_CODE
        addendum1, addendum2, result = values(ipc, command)
        ipc += 4
        @state[result] = addendum1 * addendum2
        # p "-- modified: #{result}"
      when SUM_CODE
        addendum1, addendum2, result = values(ipc, command)
        ipc += 4
        @state[result] = addendum1 + addendum2
        # p "-- modified: #{result}"
      when INPUT_CODE
        ipc += 1
        addr = @state[ipc]

        @state[addr] = @input.delete_at(0)

        # p "-- modified: #{addr}"
        ipc += 1
      when OUTPUT_CODE
        ipc += 1
        addr = @state[ipc]
        addr = @state[addr] if command[1] == 0
        puts "Output of ipc #{ipc} with addr #{addr} with value #{addr}"
        # raise "Test failed #{ipc}: #{addr} is not 0" if addr != 0
        puts addr
        @output << addr
        ipc += 1
      when JUMP_IF_TRUE_CODE
        addendum1 = @state[ipc + 1]
        addendum1 = @state[addendum1] if command[1] == 0
        next_ipc = @state[ipc + 2]
        next_ipc = @state[next_ipc] if command[2] == 0

        if addendum1 == 0
          ipc += 3
        else
          ipc = next_ipc
        end
      when JUMP_IF_FALSE_CODE
        addendum1 = @state[ipc + 1]
        addendum1 = @state[addendum1] if command[1] == 0
        next_ipc = @state[ipc + 2]
        next_ipc = @state[next_ipc] if command[2] == 0

        if addendum1 != 0
          ipc += 3
        else
          ipc = next_ipc
        end
      when LESS_THAN_CODE
        addendum1, addendum2, result = values(ipc, command)
        ipc += 4
        @state[result] = addendum1 < addendum2 ? 1_i64 : 0_i64
      when EQUALS_CODE
        addendum1, addendum2, result = values(ipc, command)
        ipc += 4
        @state[result] = addendum1 == addendum2 ? 1_i64 : 0_i64
      when EXIT_CODE
        return
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

  def values(ipc, params)
    addendum1, addendum2, result = @state[ipc + 1..ipc + 4]
    addendum1 = @state[addendum1] if params[1] == 0
    addendum2 = @state[addendum2] if params[2] == 0
    # result = @state[result] if params[3] == 0
    return {addendum1, addendum2, result}
  end
end
