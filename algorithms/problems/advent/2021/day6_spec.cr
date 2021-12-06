require "spec"
require "./day6"

describe "Day 6" do
  it "first 18" do
    fishes = "3,4,3,1,2"

    expected = [
      5,
      5,
      6,
      7,
      9,
      10,
      10,
      10,
      10,
      11,
      12,
      15,
      17,
      19,
      20,
      20,
      21,
      22,
      26,
    ]
    expected.each_with_index do |result, day|
      puts "Days: #{day}"
      actual = problem6(fishes, day)
      actual.should eq(result)
    end
  end

  it "after 18 days" do
    fishes = "3,4,3,1,2"
    actual = problem6(fishes, 18)
    actual.should eq(26)
  end

  it "after 80 days" do
    fishes = "3,4,3,1,2"
    actual = problem6(fishes, 80)
    actual.should eq(5934)
  end

  it "after 256 days" do
    fishes = "3,4,3,1,2"
    actual = problem6(fishes, 256)
    actual.should eq(26984457539)
  end
end
