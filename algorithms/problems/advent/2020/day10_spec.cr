require "spec"
require "./day10"

describe "Day 10" do
  it "part two" do
    [
      {[0, 3] of Int64, 1},
      {[0, 1, 4] of Int64, 1},
      {[0, 1, 2, 5] of Int64, 2},
      {[0, 1, 2, 3, 6] of Int64, 4},
      {[0, 1, 2, 3, 4, 7] of Int64, 7},
      {[0, 1, 2, 3, 4, 5, 7] of Int64, 20},
      {[0, 2, 3, 4, 5, 7] of Int64, 9},
      {[1, 3] of Int64, 1},
      {[3] of Int64, 1},
      {[0, 1, 3] of Int64, 2},
      {[0, 1, 3, 4] of Int64, 3},
      {[0, 1, 2, 3, 4] of Int64, 7},
      {[0, 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19, 22] of Int64, 8},
      {[0, 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31, 32, 33, 34, 35, 38, 39, 42, 45, 46, 47, 48, 49] of Int64, 19208},
    ].each do |t|
      combinations(t[0], Hash(Array(Int64), Int64).new).should eq(t[1])
    end
  end
end
