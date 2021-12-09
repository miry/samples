require "spec"
require "./day9"

describe "Day 9" do
  it "part one" do
    arr = [
      "2199943210",
      "3987894921",
      "9856789892",
      "8767896789",
      "9899965678",
    ]
    actual = problem9(arr)
    actual.should eq(15)
  end

  it "part two" do
    arr = [
      "2199943210",
      "3987894921",
      "9856789892",
      "8767896789",
      "9899965678",
    ]
    actual = problem9_part_two(arr)
    actual.should eq(1134)
  end
end
