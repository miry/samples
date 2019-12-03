require "spec"
require "./day_three"

describe "Day 3" do
  it "initializes the object" do
    subject = Grid.new
    subject.should_not eq(nil)
  end

  it "adds wire to the grid" do
    subject = Grid.new
    subject.add(["R8"])
  end

  it "find intersection of wires" do
    subject = Grid.new

    subject.add(["R8", "U2", "R5"])
    subject.add(["U1", "R10", "U3"])
    subject.intersections.should eq([{1, 8}, {2, 10}])
  end

  it "detects closest intersection" do
    subject = Grid.new

    subject.add(["R8", "U2", "L1"])
    subject.add(["U1", "R10"])
    subject.closest.should eq({1, 8})
  end
end
