require "spec"
require "./day_one"

describe "Day 1" do
  it "For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2." do
    fuel(12).should eq 2
  end

  it "For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2." do
    fuel(14).should eq 2
  end

  it "For a mass of 1969, the fuel required is 654." do
    fuel(1969).should eq 654
  end

  it "For a mass of 100756, the fuel required is 33583." do
    fuel(100756).should eq 33583
  end

  it "The Fuel Counter-Upper needs to know the total fuel requirement" do
    fuel_requirement([12, 14, 1969, 100756]).should eq 34241
  end
end
