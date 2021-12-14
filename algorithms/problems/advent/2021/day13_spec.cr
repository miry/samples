require "spec"
require "./day13"

describe "Day 13" do
  it "part one" do
    arr = [
      "6,10",
      "0,14",
      "9,10",
      "0,3",
      "10,4",
      "4,11",
      "6,0",
      "6,12",
      "4,1",
      "0,13",
      "10,12",
      "3,4",
      "3,0",
      "8,4",
      "1,10",
      "2,14",
      "8,10",
      "9,0",
      "",
      "fold along y=7",
      "fold along x=5",
      "",
    ]
    actual = problem13(arr)
    actual.should eq(17)
  end

  it "part two" do
    arr = [
      "6,10",
      "0,14",
      "9,10",
      "0,3",
      "10,4",
      "4,11",
      "6,0",
      "6,12",
      "4,1",
      "0,13",
      "10,12",
      "3,4",
      "3,0",
      "8,4",
      "1,10",
      "2,14",
      "8,10",
      "9,0",
      "",
      "fold along y=7",
      "fold along x=5",
      "",
    ]
    io = IO::Memory.new
    actual = problem13_part_two(arr, io)
    expected = {
      {4, 4} => true,
      {0, 0} => true,
      {1, 4} => true,
      {0, 3} => true,
      {0, 4} => true,
      {4, 3} => true,
      {4, 0} => true,
      {4, 2} => true,
      {4, 1} => true,
      {0, 1} => true,
      {0, 2} => true,
      {3, 4} => true,
      {3, 0} => true,
      {2, 4} => true,
      {2, 0} => true,
      {1, 0} => true,
    }
    actual.should eq(expected)
    io.to_s.rchop.should eq(<<-EOS)
    #####
    #...#
    #...#
    #...#
    #####
    EOS
  end
end
