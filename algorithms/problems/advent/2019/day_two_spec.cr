require "spec"
require "./day_two"

describe "Day 2" do
  it "process the state" do
    subject = Computer.new([99])
    subject.perform()
    subject.state.should eq [99] of Int64
  end

  it "exit early" do
    subject = Computer.new([99, 1, 0, 0, 2])
    subject.perform()
    subject.state.should eq [99, 1, 0, 0, 2] of Int64
  end

  it "simple sum math" do
    subject = Computer.new([1, 0, 0, 0, 99])
    subject.perform()
    subject.state.should eq [2, 0, 0, 0, 99] of Int64
  end

  it "simple multiplication math" do
    subject = Computer.new([2,3,0,3, 99])
    subject.perform()
    subject.state.should eq [2, 3, 0, 6, 99] of Int64
  end

  it "complex math" do
    subject = Computer.new([2,4,4,5,99,0])
    subject.perform()
    subject.state.should eq [2, 4, 4, 5, 99, 9801] of Int64
  end

  it "complex math" do
    subject = Computer.new([1,1,1,4,99,5,6,0,99])
    subject.perform()
    subject.state.should eq [30, 1, 1, 4, 2, 5, 6, 0, 99] of Int64
  end
end
