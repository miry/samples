require "spec"
require "./day_seven"

describe "Day 7" do
  it "process the state" do
    subject = Amplifier.new([99] of Int64)
    subject.perform
    subject.state.should eq [99] of Int64
  end

  it "exit early" do
    subject = Amplifier.new([99, 1, 0, 0, 2] of Int64)
    subject.perform
    subject.state.should eq [99, 1, 0, 0, 2] of Int64
  end

  it "simple sum math" do
    subject = Amplifier.new([1, 0, 0, 0, 99] of Int64)
    subject.perform
    subject.state.should eq [2, 0, 0, 0, 99] of Int64
  end

  it "simple multiplication math" do
    subject = Amplifier.new([2, 3, 0, 3, 99] of Int64)
    subject.perform
    subject.state.should eq [2, 3, 0, 6, 99] of Int64
  end

  it "complex math" do
    subject = Amplifier.new([2, 4, 4, 5, 99, 0] of Int64)
    subject.perform
    subject.state.should eq [2, 4, 4, 5, 99, 9801] of Int64
  end

  it "complex math" do
    subject = Amplifier.new([1, 1, 1, 4, 99, 5, 6, 0, 99] of Int64)
    subject.perform
    subject.state.should eq [30, 1, 1, 4, 2, 5, 6, 0, 99] of Int64
  end

  it "parameter mode multiplication" do
    subject = Amplifier.new([] of Int64)
    subject.normalize(2).should eq([2, 0, 0, 0])
  end

  it "parameter mode multiplication" do
    subject = Amplifier.new([1002, 4, 3, 4, 33] of Int64)
    subject.perform
    subject.state.should eq [1002, 4, 3, 4, 99] of Int64
  end

  it "checks conditions if input not 0 returns 1" do
    subject = Amplifier.new([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9] of Int64, [5] of Int64)
    subject.perform
    subject.output.should eq([1] of Int64)
  end

  it "checks conditions if input not 0 returns 1 using immediate mode" do
    subject = Amplifier.new([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1] of Int64, [5] of Int64)
    subject.perform
    subject.output.should eq([1] of Int64)
  end

  it "complex test" do
    commands = [3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99] of Int64
    subject = Amplifier.new(commands, [5] of Int64)
    subject.perform
    subject.output.should eq([999] of Int64)
  end

  describe ".applifiers" do
    it "calculate max thruster" do
      state = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0] of Int64
      phases = [4, 3, 2, 1, 0] of Int64
      actual = Amplifier.applifiers(state, phases)
      actual.should eq(43210)
    end

    it "calculate max thruster second sample" do
      state = [3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23, 101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0] of Int64
      phases = [0, 1, 2, 3, 4] of Int64
      actual = Amplifier.applifiers(state, phases)
      actual.should eq(54321)
    end

    it "calculate max thruster third sample" do
      state = [3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33, 1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0] of Int64
      phases = [1, 0, 4, 3, 2] of Int64
      actual = Amplifier.applifiers(state, phases)
      actual.should eq(65210)
    end
  end

  describe ".max_thruster" do
    it "calculate max thruster first case" do
      state = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0] of Int64
      actual = Amplifier.max_thruster(state, Array.new(5) { |i| i.to_i64 })
      actual.should eq(43210)
    end

    it "calculate max thruster second case" do
      state = [3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23, 101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0] of Int64
      actual = Amplifier.max_thruster(state, Array.new(5) { |i| i.to_i64 })
      actual.should eq(54321)
    end

    it "calculate max thruster third case" do
      state = [3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33, 1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0] of Int64
      actual = Amplifier.max_thruster(state, Array.new(5) { |i| i.to_i64 })
      actual.should eq(65210)
    end
  end
end
