require "spec"
require "./day25"
require "./utils"

describe "Day 25" do
  describe "problem25" do
    it "sample one" do
      input = [
        "v...>>.vv>",
        ".vv>>.vv..",
        ">>.>v>...v",
        ">>v>>.>.v.",
        "v>v.vv.v..",
        ">.>>..v...",
        ".vv..>.>v.",
        "v.v..>>v.v",
        "....v..v.>",
      ]
      actual = problem25(input)
      actual.should eq(58)
    end
  end

  describe SeaCucumber do
    describe ".parse" do
      it "sample" do
        input = [
          "...>>>>>...",
        ]
        actual = SeaCucumber.parse(input)
        actual.should be_a(SeaCucumber)
        actual.map.size.should eq(1)
        actual.map[0].size.should eq(11)
      end
    end

    describe "#step" do
      it "moves only single sea cucumber" do
        input = [
          "...>>>>>...",
        ]
        subject = SeaCucumber.parse(input)
        subject.step
        subject.map.first.join.should eq("...>>>>.>..")
        subject.step
        subject.map.first.join.should eq("...>>>.>.>.")
        subject.step
        subject.map.first.join.should eq("...>>.>.>.>")
        subject.step
        subject.map.first.join.should eq(">..>.>.>.>.")
      end

      it "moves sea cucumber south" do
        input = [
          "..........",
          ".>v....v..",
          ".......>..",
          "..........",
        ]
        subject = SeaCucumber.parse(input)
        subject.step
        actual = subject.map
        actual.should eq([
          ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
          ['.', '>', '.', '.', '.', '.', '.', '.', '.', '.'],
          ['.', '.', 'v', '.', '.', '.', '.', 'v', '>', '.'],
          ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
        ])
      end

      it "sample 2" do
        input = [
          "...>...",
          ".......",
          "......>",
          "v.....>",
          "......>",
          ".......",
          "..vvv..",
        ]
        subject = SeaCucumber.parse(input)
        subject.step
        subject.map.should eq([
          ['.', '.', 'v', 'v', '>', '.', '.'],
          ['.', '.', '.', '.', '.', '.', '.'],
          ['>', '.', '.', '.', '.', '.', '.'],
          ['v', '.', '.', '.', '.', '.', '>'],
          ['>', '.', '.', '.', '.', '.', '.'],
          ['.', '.', '.', '.', '.', '.', '.'],
          ['.', '.', '.', '.', 'v', '.', '.'],
        ])

        subject.step
        subject.map.should eq([
          ['.', '.', '.', '.', 'v', '>', '.'],
          ['.', '.', 'v', 'v', '.', '.', '.'],
          ['.', '>', '.', '.', '.', '.', '.'],
          ['.', '.', '.', '.', '.', '.', '>'],
          ['v', '>', '.', '.', '.', '.', '.'],
          ['.', '.', '.', '.', '.', '.', '.'],
          ['.', '.', '.', '.', '.', '.', '.'],
        ])
      end

      it "no moves" do
        input = [
          ">>>>>>>>>>>",
        ]
        subject = SeaCucumber.parse(input)
        actual = subject.step
        actual.should eq(false)
      end

      it "step 2" do
        input = [
          "v...>>.vv>",
          ".vv>>.vv..",
          ">>.>v>...v",
          ">>v>>.>.v.",
          "v>v.vv.v..",
          ">.>>..v...",
          ".vv..>.>v.",
          "v.v..>>v.v",
          "....v..v.>",
        ]
        subject = SeaCucumber.parse(input)
        subject.step
        subject.map.map(&.join).should eq([
          "....>.>v.>",
          "v.v>.>v.v.", # v.v>.>vvv.
          ">v>>..>v..",
          ">>v>v>.>.v",
          ".>v.v...v.",
          "v>>.>vvv..",
          "..v...>>..",
          "vv...>>vv.",
          ">.v.v..v.v",
        ])
      end
    end
  end
end
