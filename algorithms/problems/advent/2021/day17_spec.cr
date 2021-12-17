require "spec"
require "./day17"

describe "Day 17" do
  describe "problem17" do
    it "problem part one sample" do
      actual = problem17("target area: x=20..30, y=-10..-5")
      actual.should eq(45)
    end
  end

  describe "problem17_part_two" do
    it "problem part twoe sample" do
      actual = problem17_part_two("target area: x=20..30, y=-10..-5")
      actual.should eq(112)
    end
  end

  describe "find_steps_for_probe_x" do
    it "check start range" do
      actual = find_steps_for_probe_x(0..1)
      actual.should eq([{0, 0, 0}, {1, 1, 1}, {2, 1, 0}])
    end

    it "check close range" do
      actual = find_steps_for_probe_x(1..2)
      actual.should eq([{1, 1, 1}, {2, 1, 0}, {1, 2, 2}])
    end

    it "check far x range" do
      actual = find_steps_for_probe_x(20..30)
      actual.should eq([
        {5, 6, 2},
        {6, 6, 1},
        {7, 6, 0},
        {4, 7, 4},
        {5, 7, 3},
        {6, 7, 2},
        {7, 7, 1},
        {8, 7, 0}, {3, 8, 6}, {4, 8, 5}, {5, 8, 4}, {3, 9, 7}, {4, 9, 6}, {3, 10, 8},
        {2, 11, 10}, {3, 11, 9}, {2, 12, 11}, {2, 13, 12}, {2, 14, 13}, {2, 15, 14},
        {1, 20, 20}, {1, 21, 21}, {1, 22, 22}, {1, 23, 23}, {1, 24, 24}, {1, 25, 25},
        {1, 26, 26}, {1, 27, 27}, {1, 28, 28}, {1, 29, 29}, {1, 30, 30},
      ]
      )
    end
  end

  describe "find_steps_for_probe_y" do
    it "check start y range with velcoity -1" do
      actual = find_steps_for_probe_y(-1..1, -1, -1, 0, 0, 0)
      actual.should eq([{0, -1, -1, 0}, {1, -1, -2, 0}])
    end

    it "check start y range start velocity 0" do
      actual = find_steps_for_probe_y(-1..1, 0, 0, 0, 0, 0)
      actual.should eq([{0, 0, 0, 0}, {1, 0, -1, 0}, {2, 0, -2, 0}])
    end

    it "check start y range start velocity 1" do
      actual = find_steps_for_probe_y(-1..1, 1, 1, 0, 0, 0)
      actual.should eq([{0, 1, 1, 0}, {1, 1, 0, 1}, {2, 1, -1, 1}, {3, 1, -2, 1}])
    end

    it "check start y range start velocity -2" do
      actual = find_steps_for_probe_y(-1..1, -2, -2, 0, 0, 0)
      actual.should eq([{0, -2, -2, 0}])
    end

    it "check start y range start velocity 2" do
      actual = find_steps_for_probe_y(-1..1, 2, 2, 0, 0, 0)
      actual.should eq([{0, 2, 2, 0}])
    end

    it "check start y range far velocity 3" do
      actual = find_steps_for_probe_y(-10..-5, 3, 3, 0, 0, 0)
      actual.should eq([{9, 3, -6, 6}])
    end

    it "check start y range far velocity 0" do
      actual = find_steps_for_probe_y(-10..-5, 0, 0, 0, 0, 0)
      actual.should eq([{4, 0, -4, 0}, {5, 0, -5, 0}])
    end

    it "check start y range far velocity 9" do
      actual = find_steps_for_probe_y(-10..-5, 9, 9, 0, 0, 0)
      actual.should eq([{20, 9, -11, 45}])
    end
  end
end
