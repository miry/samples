require "spec"
require "./day3"

describe "Day 3" do
  it "sample part one" do
    arr = [
      "00100",
      "11110",
      "10110",
      "10111",
      "10101",
      "01111",
      "00111",
      "11100",
      "10000",
      "11001",
      "00010",
      "01010",
    ] of String
    actual = problem3(arr)
    expected = 198
    actual.should eq(expected)
  end

  it "sample part two" do
    arr = [
      "00100",
      "11110",
      "10110",
      "10111",
      "10101",
      "01111",
      "00111",
      "11100",
      "10000",
      "11001",
      "00010",
      "01010",
    ] of String
    actual = problem3_part_two(arr)
    expected = 230
    actual.should eq(expected)
  end

  it "filter oxygen first" do
    actual = problem3_filter(0, ["01"], 0)
    actual.should eq("01")
  end

  it "filter next bit" do
    actual = problem3_filter(0, ["01", "10"], 1)
    actual.should eq("10")
  end

  it "filter next bit least" do
    actual = problem3_filter(0, ["01", "10"], 0)
    actual.should eq("01")
  end
end
