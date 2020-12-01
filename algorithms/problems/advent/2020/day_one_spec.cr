require "spec"
require "./day_one"

describe "Day 1" do
  it "find the two entries that sum to 2020" do
    arr = [2019, 1] of Int64
    actual = find_two_to_sum(arr, 2020)
    expected = [2019, 1]
    actual.should eq(expected)
  end

  it "find the two entries from example" do
    arr = [1721, 979, 366, 299, 675, 1456] of Int64
    actual = find_two_to_sum(arr, 2020)
    expected = [1721, 299]
    actual.should eq(expected)
  end

  it "could not find anything" do
    arr = [2019, 10, 20, 40] of Int64
    actual = find_two_to_sum(arr, 2020)
    actual.empty?.should eq(true)
  end

  it "multiplies of entries in array" do
    arr = [1721, 979, 366, 299, 675, 1456] of Int64
    actual = mul_two_entries_to_sum(arr, 2020)
    actual.should eq(514579)
  end

  it "mutliply returns zero if could not find" do
    arr = [2019, 10, 20, 40] of Int64
    actual = mul_two_entries_to_sum(arr, 2020)
    actual.should eq(0)
  end

  it "could not find anything" do
    arr = [2019, 10, 20, 40] of Int64
    actual = find_entries_to_sum(arr, 3, 2020)
    actual.empty?.should eq(true)
  end

  it "find the three entries from example" do
    arr = [1721, 979, 366, 299, 675, 1456] of Int64
    actual = find_entries_to_sum(arr, 3, 2020)
    expected = [979, 366, 675]
    actual.should eq(expected)
  end

  it "mutliply three entries returns zero if could not find" do
    arr = [2019, 10, 20, 40] of Int64
    actual = mul_entries_to_sum(arr, 3, 2020)
    actual.should eq(0)
  end

  it "multiplies three of entries in array" do
    arr = [1721, 979, 366, 299, 675, 1456] of Int64
    actual = mul_entries_to_sum(arr, 3, 2020)
    actual.should eq(241861950)
  end
end
