require "spec"
require "./day23"

describe "Day 23" do
  describe "problem23" do
    it "sample" do
      input = [
        "#############",
        "#...........#",
        "###B#C#B#D###",
        "  #A#D#C#A#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(12521)
    end

    it "mo moves" do
      input = [
        "#############",
        "#...........#",
        "###A#B#C#D###",
        "  #A#B#C#D#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(0)
    end

    it "last move with single step" do
      input = [
        "#############",
        "#.......D...#",
        "###A#B#C#.###",
        "  #A#B#C#D#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(2000)
    end

    it "last two moves" do
      input = [
        "#############",
        "#.D.....D...#",
        "###A#B#C#.###",
        "  #A#B#C#.#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(3000 + 8000)
    end

    it "blocking last piece moves" do
      input = [
        "#############",
        "#.........DC#",
        "###A#B#.#.###",
        "  #A#B#C#D#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(2000 + 400 + 100)
    end

    it "sample sub 1" do
      input = [
        "#############",
        "#.........A.#",
        "###.#B#C#D###",
        "  #A#B#C#D#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(8)
    end

    it "sample sub 2" do
      input = [
        "#############",
        "#.....D.D.A.#",
        "###.#B#C#.###",
        "  #A#B#C#.#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(7008)
    end

    it "sample sub 3" do
      input = [
        "#############",
        "#.....D.....#",
        "###.#B#C#D###",
        "  #A#B#C#A#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(9011)
    end

    it "sample sub 4" do
      input = [
        "#############",
        "#.....D.....#",
        "###B#.#C#D###",
        "  #A#B#C#A#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(9051)
    end

    it "sample sub 5" do
      input = [
        "#############",
        "#...B.......#",
        "###B#.#C#D###",
        "  #A#D#C#A#",
        "  #########",
      ]
      actual = problem23(input)
      actual.should eq(9051 + 3000 + 30)
    end
  end

  describe "problem23_part_two" do
    it "sample" do
      input = [
        "#############",
        "#...........#",
        "###B#C#B#D###",
        "  #A#D#C#A#",
        "  #########",
      ]
      actual = problem23_part_two(input)
      actual.should eq(44169)
    end

    it "mo moves" do
      input = [
        "#############",
        "#...........#",
        "###A#B#C#D###",
        "  #A#B#C#D#",
        "  #########",
      ]
      actual = problem23_part_two(input)
      actual.should eq(28188)
    end
  end
end
