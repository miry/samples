require "spec"
require "./day11"

describe "Day 11" do
  it "part one" do
    arr = [
      "5483143223",
      "2745854711",
      "5264556173",
      "6141336146",
      "6357385478",
      "4167524645",
      "2176841721",
      "6882881134",
      "4846848554",
      "5283751526",
    ]
    actual = problem11(arr)
    actual.should eq(1656)
  end

  it "check flash simple" do
    arr = [
      "11111",
      "19991",
      "19191",
      "19991",
      "11111",
    ]
    octopuses = octopuses_init(arr)
    actual = octopuses_flash(octopuses)

    expected = [
      "34543",
      "40004",
      "50005",
      "40004",
      "34543",
    ]

    actual.should eq(9)
    octopuses.should eq(octopuses_init(expected))
  end

  it "check flash simple step 2" do
    arr = [
      "34543",
      "40004",
      "50005",
      "40004",
      "34543",
    ]
    octopuses = octopuses_init(arr)
    actual = octopuses_flash(octopuses)

    expected = [
      "45654",
      "51115",
      "61116",
      "51115",
      "45654",
    ]

    actual.should eq(0)
    octopuses.should eq(octopuses_init(expected))
  end
end
