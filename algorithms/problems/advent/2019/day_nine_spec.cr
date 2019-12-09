require "spec"
require "./day_nine"

describe "Day 9" do
  it "process the state" do
    subject = Boost.new([99] of Int64)
    subject.perform rescue nil
    subject.state.should eq [99] of Int64
  end

  it "exit early" do
    subject = Boost.new([99, 1, 0, 0, 2] of Int64)
    subject.perform rescue nil
    subject.state.should eq [99, 1, 0, 0, 2] of Int64
  end

  it "simple sum math" do
    subject = Boost.new([1, 0, 0, 0, 99] of Int64)
    subject.perform rescue nil
    subject.state.should eq [2, 0, 0, 0, 99] of Int64
  end

  it "simple multiplication math" do
    subject = Boost.new([2, 3, 0, 3, 99] of Int64)
    subject.perform rescue nil
    subject.state.should eq [2, 3, 0, 6, 99] of Int64
  end

  it "complex math" do
    subject = Boost.new([2, 4, 4, 5, 99, 0] of Int64)
    subject.perform rescue nil
    subject.state.should eq [2, 4, 4, 5, 99, 9801] of Int64
  end

  it "complex math" do
    subject = Boost.new([1, 1, 1, 4, 99, 5, 6, 0, 99] of Int64)
    subject.perform rescue nil
    subject.state.should eq [30, 1, 1, 4, 2, 5, 6, 0, 99] of Int64
  end

  it "parameter mode multiplication" do
    subject = Boost.new([] of Int64)
    subject.normalize(2).should eq([2, 0, 0, 0])
  end

  it "parameter mode multiplication" do
    subject = Boost.new([1002, 4, 3, 4, 33] of Int64)
    subject.perform rescue nil
    subject.state.should eq [1002, 4, 3, 4, 99] of Int64
  end

  it "checks conditions if input not 0 returns 1" do
    subject = Boost.new([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9] of Int64, [5] of Int64)
    subject.perform
    subject.output.should eq([1] of Int64)
  end

  it "checks conditions if input not 0 returns 1 using immediate mode" do
    subject = Boost.new([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1] of Int64, [5] of Int64)
    subject.perform
    subject.output.should eq([1] of Int64)
  end

  it "complex test" do
    commands = [3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99] of Int64
    subject = Boost.new(commands, [5] of Int64)
    subject.perform
    subject.output.should eq([999] of Int64)
  end

  describe ".amplifiers" do
    it "calculate max thruster" do
      state = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0] of Int64
      phases = [4, 3, 2, 1, 0] of Int64
      actual = Boost.amplifiers(state, phases)
      actual.should eq(43210)
    end

    it "calculate max thruster second sample" do
      state = [3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23, 101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0] of Int64
      phases = [0, 1, 2, 3, 4] of Int64
      actual = Boost.amplifiers(state, phases)
      actual.should eq(54321)
    end

    it "calculate max thruster third sample" do
      state = [3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33, 1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0] of Int64
      phases = [1, 0, 4, 3, 2] of Int64
      actual = Boost.amplifiers(state, phases)
      actual.should eq(65210)
    end
  end

  describe ".max_thruster" do
    it "calculate max thruster first case" do
      state = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0] of Int64
      actual = Boost.max_thruster(state, Array.new(5) { |i| i.to_i64 })
      actual.should eq(43210)
    end

    it "calculate max thruster second case" do
      state = [3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23, 101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0] of Int64
      actual = Boost.max_thruster(state, Array.new(5) { |i| i.to_i64 })
      actual.should eq(54321)
    end

    it "calculate max thruster third case" do
      state = [3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33, 1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0] of Int64
      actual = Boost.max_thruster(state, Array.new(5) { |i| i.to_i64 })
      actual.should eq(65210)
    end
  end

  describe ".amplifiers_loop" do
    it "calculate firt case" do
      state : Array(Int64) = [3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26, 27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5] of Int64
      phases : Array(Int64) = [9, 8, 7, 6, 5] of Int64
      actual = Boost.amplifiers_loop(state, phases)
      actual.should eq(139629729)
    end

    it "calculate second case" do
      state : Array(Int64) = [3, 52, 1001, 52, -5, 52, 3, 53, 1, 52, 56, 54, 1007, 54, 5, 55, 1005, 55, 26, 1001, 54, -5, 54, 1105, 1, 12, 1, 53, 54, 53, 1008, 54, 0, 55, 1001, 55, 1, 55, 2, 53, 55, 53, 4, 53, 1001, 56, -1, 56, 1005, 56, 6, 99, 0, 0, 0, 0, 10] of Int64
      phases : Array(Int64) = [9, 7, 8, 5, 6] of Int64
      actual = Boost.amplifiers_loop(state, phases)
      actual.should eq(18216)
    end
  end

  describe ".max_thruster_loop" do
    it "calculate firt case" do
      state : Array(Int64) = [3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26, 27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5] of Int64
      phases : Array(Int64) = [5, 6, 7, 8, 9] of Int64
      actual = Boost.max_thruster_loop(state, phases)
      actual.should eq(139629729)
    end

    it "calculate second case" do
      state : Array(Int64) = [3, 52, 1001, 52, -5, 52, 3, 53, 1, 52, 56, 54, 1007, 54, 5, 55, 1005, 55, 26, 1001, 54, -5, 54, 1105, 1, 12, 1, 53, 54, 53, 1008, 54, 0, 55, 1001, 55, 1, 55, 2, 53, 55, 53, 4, 53, 1001, 56, -1, 56, 1005, 56, 6, 99, 0, 0, 0, 0, 10] of Int64
      phases : Array(Int64) = [5, 6, 7, 8, 9] of Int64
      actual = Boost.max_thruster_loop(state, phases)
      actual.should eq(18216)
    end
  end

  describe "relative base" do
    it "should print relative base" do
      subject = Boost.new([109, 34, 204, -34, 204, -29, 99] of Int64)
      subject.perform
      subject.output.should eq([109] of Int64)
      subject.perform
      subject.output.should eq([109, -29] of Int64)
    end

    it "access out of state" do
      subject = Boost.new([4, 199, 99] of Int64)
      subject.perform
      subject.output.should eq([0] of Int64)
    end

    it "cpopy itself" do
      subject = Boost.new([109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99] of Int64)
      subject.perform
      subject.output.should eq([109] of Int64)
      15.times do
        subject.perform
      end
      subject.output.should eq([109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99] of Int64)
    end

    it "should output a 16-digit number" do
      subject = Boost.new([1102, 34915192, 34915192, 7, 4, 7, 99, 0] of Int64)
      subject.perform
      subject.output.should eq([1219070632396864] of Int64)
    end

    it "should output the large number in the middle" do
      subject = Boost.new([104, 1125899906842624, 99] of Int64)
      subject.perform
      subject.output.should eq([1125899906842624] of Int64)
    end
  end
end
