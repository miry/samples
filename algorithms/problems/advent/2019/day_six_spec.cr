require "spec"
require "./day_six"

describe "Day 6" do
  it "orbits setup" do
    input = ["COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"]
    map = OrbitsMap.new(input)
    map.should_not eq(nil)
  end

  it "count orbits for D" do
    input = ["COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"]
    map = OrbitsMap.new(input)
    map.orbits("D").should eq(3)
  end

  it "count orbits for L" do
    input = ["COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"]
    map = OrbitsMap.new(input)
    map.orbits("L").should eq(7)
  end

  it "count orbits for COM" do
    input = ["COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"]
    map = OrbitsMap.new(input)
    map.orbits("COM").should eq(0)
  end

  it "total count of orbits" do
    input = ["COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"]
    map = OrbitsMap.new(input)
    map.all_orbits.should eq(42)
  end

  it "total count of different order orbits" do
    input = ["B)C", "COM)B", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"]
    map = OrbitsMap.new(input)
    map.all_orbits.should eq(42)
  end
end
