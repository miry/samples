require "spec"
require "./day21"

describe "Day 21" do
  describe "problem21" do
    it "sample" do
      input = [
        "Player 1 starting position: 4",
        "Player 2 starting position: 8",
      ]
      actual = problem21(input)
      actual.should eq(739785)
    end
  end

  describe "problem21_part_two" do
    it "sample" do
      input = [
        "Player 1 starting position: 4",
        "Player 2 starting position: 8",
      ]
      actual = problem21_part_two(input)
      actual.should eq(444356092776315)
    end
  end

  describe "game" do
    it "exit code 1" do
      cache = Hash(Tuple(Array(Int32), Array(Int32), Int32, Int32, Int32), Hash(Int32, Int64)).new
      actual = game([4, 8], [0, 0], 0, 0, 0, cache, 1)
      actual.should eq({0 => 27, 1 => 0})
    end

    it "exit code 2" do
      cache = Hash(Tuple(Array(Int32), Array(Int32), Int32, Int32, Int32), Hash(Int32, Int64)).new
      actual = game([4, 8], [0, 0], 0, 0, 0, cache, 2)
      actual.should eq({0 => 183, 1 => 156})
    end

    it "exit code 2 and win player 0" do
      cache = Hash(Tuple(Array(Int32), Array(Int32), Int32, Int32, Int32), Hash(Int32, Int64)).new
      actual = game([4, 8], [0, 0], 0, 3, 3, cache, 2)
      actual.should eq({0 => 1, 1 => 0})
    end

    it "exit code 2 and player 1 did not so turn of player 2 and then player 1 again" do
      cache = Hash(Tuple(Array(Int32), Array(Int32), Int32, Int32, Int32), Hash(Int32, Int64)).new
      actual = game([4, 8], [0, 0], 0, 7, 3, cache, 2)
      actual.should eq({0 => 27, 1 => 26})
    end

    it "exit code 2 turns of player2" do
      cache = Hash(Tuple(Array(Int32), Array(Int32), Int32, Int32, Int32), Hash(Int32, Int64)).new
      actual = game([1, 8], [1, 0], 1, 3, 3, cache, 2)
      actual.should eq({0 => 27, 1 => 0})
    end

    it "exit code 2 3rd layer" do
      cache = Hash(Tuple(Array(Int32), Array(Int32), Int32, Int32, Int32), Hash(Int32, Int64)).new
      actual = game([1, 1], [1, 1], 0, 0, 0, cache, 2)
      actual.should eq({0 => 27, 1 => 0})
    end
  end
end
