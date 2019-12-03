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
    subject.intersections.should eq (Set.new [{8, 1, 18}, {10, 2, 24}])
  end

  it "detects closest intersection" do
    subject = Grid.new

    subject.add(["R8", "U2", "L1"])
    subject.add(["U1", "R10"])
    subject.closest.should eq(18)
  end

  it "first sample form defenition" do
    subject = Grid.new
    subject.add("R8,U5,L5,D3".split(","))
    subject.add("U7,R6,D4,L4".split(","))
    subject.intersections.should eq(Set.new [{3, 3, 40}, {6, 5, 30}])
    subject.closest.should eq(30)
  end

  it "second sample from task" do
    subject = Grid.new
    subject.add("R75,D30,R83,U83,L12,D49,R71,U7,L72".split(","))
    subject.add("U62,R66,U55,R34,D71,R55,D58,R83".split(","))
    subject.intersections.should eq(Set.new [{158, -12, 610}, {146, 46, 624}, {155, 4, 726}, {155, 11, 850}])
    subject.closest.should eq(610)
  end

  it "third sample from task" do
    subject = Grid.new
    subject.add("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51".split(","))
    subject.add("U98,R91,D20,R16,D67,R40,U7,R15,U6,R7".split(","))
    subject.closest.should eq(410)
  end
end
