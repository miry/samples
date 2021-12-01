require "spec"
require "./day1"

describe "Day 1" do
  it "increased values single" do
    arr = [
      199,
      200,
      208,
      210,
      200,
      207,
      240,
      269,
      260,
      263,
    ] of Int64
    actual = increased_values(arr)
    expected = 7
    actual.should eq(expected)
  end

  it "increased moving window" do
    arr = [
      199,
      200,
      208,
      210,
      200,
      207,
      240,
      269,
      260,
      263,
    ] of Int64
    actual = increased_moving_window(arr, 3)
    expected = 5
    actual.should eq(expected)
  end
end
