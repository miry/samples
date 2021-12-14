require "spec"
require "./day14"

describe "Day 14" do
  it "test part one" do
    input = [
      "NNCB",
      "",
      "CH -> B",
      "HH -> N",
      "CB -> H",
      "NH -> C",
      "HB -> C",
      "HC -> B",
      "HN -> C",
      "NN -> C",
      "BH -> H",
      "NC -> B",
      "NB -> B",
      "BN -> B",
      "BB -> N",
      "BC -> B",
      "CC -> N",
      "CN -> C",
    ]
    actual = problem14(input, 10)
    actual.should eq(1588)
  end

  it "with single iteration" do
    input = [
      "NNCB",
      "",
      "CH -> B",
      "HH -> N",
      "CB -> H",
      "NH -> C",
      "HB -> C",
      "HC -> B",
      "HN -> C",
      "NN -> C",
      "BH -> H",
      "NC -> B",
      "NB -> B",
      "BN -> B",
      "BB -> N",
      "BC -> B",
      "CC -> N",
      "CN -> C",
    ]
    actual = problem14(input, 1) # NCNBCHB
    actual.should eq(1)
  end

  it "with second iteration" do
    input = [
      "NNCB",
      "",
      "CH -> B",
      "HH -> N",
      "CB -> H",
      "NH -> C",
      "HB -> C",
      "HC -> B",
      "HN -> C",
      "NN -> C",
      "BH -> H",
      "NC -> B",
      "NB -> B",
      "BN -> B",
      "BB -> N",
      "BC -> B",
      "CC -> N",
      "CN -> C",
    ]
    actual = problem14(input, 2) # NBCCNBBBCBHCB
    actual.should eq(5)
  end

  it "generate template zero step" do
    rules = {
      "CH" => 'B',
      "HH" => 'N',
      "CB" => 'H',
      "NH" => 'C',
      "HB" => 'C',
      "HC" => 'B',
      "HN" => 'C',
      "NN" => 'C',
      "BH" => 'H',
      "NC" => 'B',
      "NB" => 'B',
      "BN" => 'B',
      "BB" => 'N',
      "BC" => 'B',
      "CC" => 'N',
      "CN" => 'C',
    }

    actual = generate_template('N', 'N', 0, rules)
    actual.should eq({'N' => 2})
  end

  it "generate template single step" do
    rules = {
      "CH" => 'B',
      "HH" => 'N',
      "CB" => 'H',
      "NH" => 'C',
      "HB" => 'C',
      "HC" => 'B',
      "HN" => 'C',
      "NN" => 'C',
      "BH" => 'H',
      "NC" => 'B',
      "NB" => 'B',
      "BN" => 'B',
      "BB" => 'N',
      "BC" => 'B',
      "CC" => 'N',
      "CN" => 'C',
    }

    actual = generate_template('N', 'N', 1, rules)
    actual.should eq({'N' => 2, 'C' => 1})
  end

  it "generate template two step" do
    rules = {
      "CH" => 'B',
      "HH" => 'N',
      "CB" => 'H',
      "NH" => 'C',
      "HB" => 'C',
      "HC" => 'B',
      "HN" => 'C',
      "NN" => 'C',
      "BH" => 'H',
      "NC" => 'B',
      "NB" => 'B',
      "BN" => 'B',
      "BB" => 'N',
      "BC" => 'B',
      "CC" => 'N',
      "CN" => 'C',
    }

    actual = generate_template('N', 'N', 2, rules)
    actual.should eq({'N' => 2, 'C' => 2, 'B' => 1})
  end

  it "generate template use cache for CN" do
    rules = {
      "CH" => 'B',
      "HH" => 'N',
      "CB" => 'H',
      "NH" => 'C',
      "HB" => 'C',
      "HC" => 'B',
      "HN" => 'C',
      "NN" => 'C',
      "BH" => 'H',
      "NC" => 'B',
      "NB" => 'B',
      "BN" => 'B',
      "BB" => 'N',
      "BC" => 'B',
      "CC" => 'N',
      "CN" => 'C',
    }

    actual = generate_template('N', 'N', 3, rules)
    actual.should eq({'N' => 3, 'C' => 3, 'B' => 3})
  end
end
