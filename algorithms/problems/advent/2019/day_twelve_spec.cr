require "spec"
require "./day_twelve"

describe "Day 12" do
  describe Moon do
    it "calculates velocities" do
      subject = Moon.new(-1, 0, 2)
      moons = [
        Moon.new(2, -10, -7),
        Moon.new(4, -8, 8),
        Moon.new(3, 5, -1),
      ]
      subject.velocity(moons)
      subject.vel.should eq([3, -1, -1])
    end

    it "change by step" do
      subject = Moon.new(-1, 0, 2)
      moons = [
        Moon.new(2, -10, -7),
        Moon.new(4, -8, 8),
        Moon.new(3, 5, -1),
      ]
      subject.velocity(moons)
      subject.step
      subject.x.should eq(2)
      subject.y.should eq(-1)
      subject.z.should eq(1)
    end

    it "calculate pot" do
      subject = Moon.new 2, 1, -3
      subject.vel = [-3, -2, 1] of Int64
      subject.pot.should eq(6)
    end

    it "calculate kin" do
      subject = Moon.new 2, 1, -3
      subject.vel = [-3, -2, 1] of Int64
      subject.kin.should eq(6)
    end

    it "calculate total" do
      subject = Moon.new 2, 1, -3
      subject.vel = [-3, -2, 1] of Int64
      subject.total.should eq(36)
    end

    it "calculate total energy after 10 steps" do
      moons = [
        Moon.new(-1, 0, 2),
        Moon.new(2, -10, -7),
        Moon.new(4, -8, 8),
        Moon.new(3, 5, -1),
      ]
      actual = Moon.total_energy_after(moons, 10)
      actual.should eq(179)
    end

    it "parse from string" do
      subject = Moon.parse("<x=-1, y=7, z=3>")
      subject.x.should eq(-1)
      subject.y.should eq(7)
      subject.z.should eq(3)
    end
  end
end
