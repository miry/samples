require "spec"
require "./day2"

describe "Day 2" do
  it "sample part one" do
    arr = [
      "forward 5",
      "down 5",
      "forward 8",
      "up 3",
      "down 8",
      "forward 2",
    ] of String
    actual = problem2(arr)
    expected = 150
    actual.should eq(expected)
  end

  it "sample part two" do
    arr = [
      "forward 5",
      "down 5",
      "forward 8",
      "up 3",
      "down 8",
      "forward 2",
    ] of String
    actual = problem2_part_two(arr)
    expected = 900
    actual.should eq(expected)
  end
end
