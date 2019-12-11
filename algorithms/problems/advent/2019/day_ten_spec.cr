require "spec"
require "./day_ten"

describe "Day 10: Monitoring station" do
  it "initialize asteroid map" do
    subject = AsteroidMap.new(["....###"] of String)
    subject.size.should eq({1, 7})
  end

  describe "#coefficient" do
    it "return coefficient same" do
      subject = AsteroidMap.new([] of String)
      subject.coefficient({0, 0}, {1, 1}).should eq({1.0, 1.0, 1.0})
      subject.coefficient({1, 1}, {0, 0}).should eq({1.0, -1.0, -1.0})
      subject.coefficient({10, 10}, {0, 0}).should eq({1.0, -1.0, -1.0})
    end
  end

  it "show all cells with asteroids" do
    raw = [
      ".#..#",
      ".....",
      "#####",
      "....#",
      "...##",
    ]
    subject = AsteroidMap.new(raw)
    subject.asteroids.should eq([{1, 0}, {4, 0}, {0, 2}, {1, 2}, {2, 2}, {3, 2}, {4, 2}, {4, 3}, {3, 4}, {4, 4}])
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
    subject.suggestion.should eq({8, {3, 4}})
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
    subject.suggestion.should eq({33, {5, 8}})
  end

  it "second example close to 0,8 and 5,8" do
    subject = AsteroidMap.new([] of String)
    subject.coefficient({5, 8}, {0, 8}).should eq({0.0, 0.0, -1.0})
    subject.coefficient({5, 8}, {1, 8}).should eq({0.0, 0.0, -1.0})
    subject.coefficient({5, 8}, {8, 8}).should eq({0.0, 0.0, 1.0})
    subject.coefficient({5, 8}, {4, 7}).should eq({1.0, -1.0, -1.0})
    subject.coefficient({5, 8}, {3, 6}).should eq({1.0, -1.0, -1.0})
    subject.coefficient({5, 8}, {2, 5}).should eq({1.0, -1.0, -1.0})
    subject.coefficient({5, 8}, {1, 4}).should eq({1.0, -1.0, -1.0})
  end

  it "second example asterdois around 5,8" do
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
    subject.assteroids_coeficients_around({5, 8}).size.should eq(33)
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
    subject.suggestion.should eq({35, {1, 2}})
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
    subject.suggestion.should eq({41, {6, 3}})
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
    subject.suggestion.should eq({210, {11, 13}})
  end

  describe ".vaporized_in" do
    it "checks for visible asterdois" do
      raw = [
        ".#....#####...#..",
        "##...##.#####..##",
        "##...#...#.#####.",
        "..#.....X...###..",
        "..#.#.....#....##",
      ]
      subject = AsteroidMap.new(raw)

      subject.assteroids_coeficients_around({8, 3}).size.should eq(30)
    end

    it "distance between points" do
      subject = AsteroidMap.new [] of String
      subject.distance({8, 3}, {16, 1}).should eq(10)
      subject.distance({8, 3}, {12, 2}).should eq(5)
      subject.distance({8, 3}, {8, 1}).should eq(2)
    end

    it "starts with clockwise" do
      raw = [
        ".#....#####...#..",
        "##...##.#####..##",
        "##...#...#.#####.",
        "..#.....X...###..",
        "..#.#.....#....##",
      ]
      subject = AsteroidMap.new(raw)
      subject.vaporized_in(1).should eq({8, 1})
      subject.vaporized_in(2).should eq({9, 0})
      subject.vaporized_in(3).should eq({9, 1})
      subject.vaporized_in(4).should eq({10, 0})
      subject.vaporized_in(9).should eq({15, 1})
      subject.vaporized_in(10).should eq({12, 2})
      subject.vaporized_in(11).should eq({13, 2})
      subject.vaporized_in(12).should eq({14, 2})
      subject.vaporized_in(13).should eq({15, 2})
      subject.vaporized_in(14).should eq({12, 3})
      subject.vaporized_in(15).should eq({16, 4})
      subject.vaporized_in(16).should eq({15, 4})
      subject.vaporized_in(17).should eq({10, 4})
      subject.vaporized_in(18).should eq({4, 4})
      subject.vaporized_in(19).should eq({2, 4})
      subject.vaporized_in(20).should eq({2, 3})
      subject.vaporized_in(27).should eq({5, 1})
      subject.vaporized_in(36).should eq({14, 3})
    end

    it "starts with big clockwise" do
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
      subject.vaporized_in(1).should eq({11, 12})
      subject.vaporized_in(2).should eq({12, 1})
      subject.vaporized_in(20).should eq({16, 0})
      subject.vaporized_in(50).should eq({16, 9})
      subject.vaporized_in(100).should eq({10, 16})
    end
  end
end
