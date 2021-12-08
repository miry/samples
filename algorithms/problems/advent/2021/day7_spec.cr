require "spec"
require "./day7"

describe "Day 7" do
  it "part one" do
    input = "16,1,2,0,4,2,7,1,2,14"
    actual = problem7(input)
    expected = 37
    actual.should eq(expected)
  end

  it "part two" do
    input = "16,1,2,0,4,2,7,1,2,14"
    actual = problem7_part_two(input)
    expected = 168
    actual.should eq(expected)
  end
end
