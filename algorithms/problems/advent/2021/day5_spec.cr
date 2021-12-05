require "spec"
require "./day5"

describe "Day 5 doit sample part one" do
  it "problem part one" do
    arr = [
      "0,9 -> 5,9",
      "8,0 -> 0,8",
      "9,4 -> 3,4",
      "2,2 -> 2,1",
      "7,0 -> 7,4",
      "6,4 -> 2,0",
      "0,9 -> 2,9",
      "3,4 -> 1,4",
      "0,0 -> 8,8",
      "5,5 -> 8,2",
    ] of String
    actual = problem5(arr)
    expected = 5
    actual.should eq(expected)
  end

  it "problem part two" do
    arr = [
      "0,9 -> 5,9",
      "8,0 -> 0,8",
      "9,4 -> 3,4",
      "2,2 -> 2,1",
      "7,0 -> 7,4",
      "6,4 -> 2,0",
      "0,9 -> 2,9",
      "3,4 -> 1,4",
      "0,0 -> 8,8",
      "5,5 -> 8,2",
    ] of String
    actual = problem5_part_two(arr)
    expected = 12
    actual.should eq(expected)
  end
end
