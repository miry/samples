require "spec"
require "./day_five"

describe "Day 5" do
  it "process the state" do
    subject = AirCondition.new([99] of Int64)
    subject.perform
    subject.state.should eq [99] of Int64
  end

  it "exit early" do
    subject = AirCondition.new([99, 1, 0, 0, 2] of Int64)
    subject.perform
    subject.state.should eq [99, 1, 0, 0, 2] of Int64
  end

  it "simple sum math" do
    subject = AirCondition.new([1, 0, 0, 0, 99] of Int64)
    subject.perform
    subject.state.should eq [2, 0, 0, 0, 99] of Int64
  end

  it "simple multiplication math" do
    subject = AirCondition.new([2, 3, 0, 3, 99] of Int64)
    subject.perform
    subject.state.should eq [2, 3, 0, 6, 99] of Int64
  end

  it "complex math" do
    subject = AirCondition.new([2, 4, 4, 5, 99, 0] of Int64)
    subject.perform
    subject.state.should eq [2, 4, 4, 5, 99, 9801] of Int64
  end

  it "complex math" do
    subject = AirCondition.new([1, 1, 1, 4, 99, 5, 6, 0, 99] of Int64)
    subject.perform
    subject.state.should eq [30, 1, 1, 4, 2, 5, 6, 0, 99] of Int64
  end

  it "parameter mode multiplication" do
    subject = AirCondition.new([] of Int64)
    subject.normalize(2).should eq([2, 0, 0, 0])
  end

  it "parameter mode multiplication" do
    subject = AirCondition.new([1002, 4, 3, 4, 33] of Int64)
    subject.perform
    subject.state.should eq [1002, 4, 3, 4, 99] of Int64
  end
end
