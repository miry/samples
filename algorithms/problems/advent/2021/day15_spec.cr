require "spec"
require "./day15"

describe "Day 15" do
  it "sample for part one" do
    input = [
      "1163751742",
      "1381373672",
      "2136511328",
      "3694931569",
      "7463417111",
      "1319128137",
      "1359912421",
      "3125421639",
      "1293138521",
      "2311944581",
    ]
    actual = problem15(input)
    actual.should eq(40)
  end

  it "move left if possible" do
    input = [
      "1163751742",
      "1381373672",
      "2136511328",
      "3694931569",
      "7463417111",
      "1319128137",
      "1359912421",
      "3125421639",
      "1293138521",
      "2311944581",
    ]
    actual = problem15(input)
    actual.should eq(40)
  end

  it "small 2x2" do
    input = [
      "11",
      "13",
    ]
    actual = problem15(input)
    actual.should eq(4)
  end

  it "small 3x3" do
    input = [
      "116",
      "138",
      "213",
    ]
    actual = problem15(input)
    actual.should eq(7)
  end

  it "small 5x5" do
    input = [
      "11199",
      "99199",
      "91199",
      "91999",
      "91111",
    ]
    actual = problem15(input)
    actual.should eq(10)
  end

  it "small 5x5" do
    input = [
      "1199",
      "9199",
      "1199",
      "1999",
      "1111",
    ]
    actual = problem15(input)
    actual.should eq(9)
  end

  it "small 5x5 ver2" do
    input = [
      "11119",
      "99919",
      "91119",
      "91999",
      "91111",
    ]
    actual = problem15_part_two(input)
    actual.should eq(204)
  end

  it "sample for part two" do
    input = [
      "1163751742",
      "1381373672",
      "2136511328",
      "3694931569",
      "7463417111",
      "1319128137",
      "1359912421",
      "3125421639",
      "1293138521",
      "2311944581",
    ]
    actual = problem15_part_two(input)
    actual.should eq(315)
  end

  it "small 5x5 part two" do
    input = [
      "11119",
      "99919",
      "91119",
      "91999",
      "91111",
    ]
    actual = problem15_part_two(input)
    actual.should eq(204)
  end

  it "small pattern" do
    input = [
      "1111119",
      "9999919",
      "9999919",
      "9111919",
      "9191119",
      "9199999",
      "9199999",
      "9199111",
      "9111191",
    ]
    actual = problem15(input)
    actual.should eq(26)
  end

  it "small pattern part two" do
    input = [
      "1111119",
      "9999919",
      "9999919",
      "9111919",
      "9191119",
      "9199999",
      "9199999",
      "9199111",
      "9111191",
    ]
    actual = problem15_part_two(input)
    actual.should eq(316)
  end

  it "example" do
    input = [
      "11111",
      "99911",
      "11111",
      "11999",
      "11111",
    ]
    actual = problem15_part_two(input)
    actual.should eq(215)
  end
end
