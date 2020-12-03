require "spec"
require "./day_three"

describe "Day 3" do
  describe TobogganTrajectory do
    describe ".new" do
      it "loads map" do
        subject = TobogganTrajectory.new(["..##......."])
        subject.rows.should eq(1)
        subject.cols.should eq(11)
      end

      it "loads multiline map" do
        subject = TobogganTrajectory.new(["..##.......", "#...#...#.."])
        subject.rows.should eq(2)
        subject.cols.should eq(11)
      end
    end

    describe "#cell" do
      it "gets tree from cell in range" do
        subject = TobogganTrajectory.new(["..##.......", "#...#...#.."])
        actual = subject.cell(0, 3)
        actual.should eq('#')
      end

      it "gets tree from cell out of col range" do
        subject = TobogganTrajectory.new(["..##.......", "#...#...#.."])
        actual = subject.cell(0, 14)
        actual.should eq('#')
      end
    end

    describe "#traversing" do
      it "returns all cell by steps" do
        subject = TobogganTrajectory.new(["..##.......", "#...#...#.."])
        actual = subject.traversing(3, 1)
        actual.should eq(".")
      end
    end
  end
end
