require "spec"
require "./day_ten"

describe "Day 10: Monitoring station" do
  it "initialize asteroid map" do
    subject = AsteroidMap.new(["....###"] of String)
    subject.size.should eq({1, 7})
  end

  it "small first example" do
    raw = [
      ".#..#",
      ".....",
      "#####",
      "....#",
      "...##",
    ]
    subject = AsteroidMap.new(raw)
    subject.suggestion.should eq({3, 4})
  end

  it "second example" do
    raw = [
      "......#.#.",
      "#..#.#....",
      "..#######.",
      ".#.#.###..",
      ".#..#.....",
      "..#....#.#",
      "#..#....#.",
      ".##.#..###",
      "##...#..#.",
      ".#....####",
    ]
    subject = AsteroidMap.new(raw)
    subject.suggestion.should eq({5, 8})
  end

  it "third example" do
    raw = [
      "#.#...#.#.",
      ".###....#.",
      ".#....#...",
      "##.#.#.#.#",
      "....#.#.#.",
      ".##..###.#",
      "..#...##..",
      "..##....##",
      "......#...",
      ".####.###.",
    ]
    subject = AsteroidMap.new(raw)
    subject.suggestion.should eq({1, 2})
  end

  it "forth example" do
    raw = [
      ".#..#..###",
      "####.###.#",
      "....###.#.",
      "..###.##.#",
      "##.##.#.#.",
      "....###..#",
      "..#.#..#.#",
      "#..#.#.###",
      ".##...##.#",
      ".....#.#..",
    ]
    subject = AsteroidMap.new(raw)
    subject.suggestion.should eq({6, 3})
  end

  it "fifth example" do
    raw = [
      ".#..##.###...#######",
      "##.############..##.",
      ".#.######.########.#",
      ".###.#######.####.#.",
      "#####.##.#.##.###.##",
      "..#####..#.#########",
      "####################",
      "#.####....###.#.#.##",
      "##.#################",
      "#####.##.###..####..",
      "..######..##.#######",
      "####.##.####...##..#",
      ".#####..#.######.###",
      "##...#.##########...",
      "#.##########.#######",
      ".####.#.###.###.#.##",
      "....##.##.###..#####",
      ".#.#.###########.###",
      "#.#.#.#####.####.###",
      "###.##.####.##.#..##",
    ]
    subject = AsteroidMap.new(raw)
    subject.suggestion.should eq({11, 13})
  end
end
