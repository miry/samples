require "spec"
require "./day12"

describe "Day 12" do
  it "paths single" do
    arr = [
      "start-A",
      "A-end",
    ]
    connections = connections_parse(arr)
    actual = find_paths(connections, ["start"], Set(String).new)
    expected = [
      ["start", "A", "end"],
    ]
    actual.should eq(expected)
  end

  it "paths single dead end" do
    arr = [
      "start-A",
      "start-b",
      "A-end",
    ]
    connections = connections_parse(arr)
    actual = find_paths(connections, ["start"], Set(String).new)
    expected = [
      ["start", "A", "end"],
    ]
    actual.should eq(expected)
  end

  it "paths single two variants" do
    arr = [
      "start-A",
      "start-b",
      "A-end",
      "b-end",
    ]
    connections = connections_parse(arr)
    actual = find_paths(connections, ["start"], Set(String).new)
    expected = [
      ["start", "A", "end"],
      ["start", "b", "end"],
    ]
    actual.should eq(expected)
  end

  it "paths single four variants" do
    arr = [
      "start-A",
      "start-b",
      "A-b",
      "A-end",
      "b-end",
    ]
    connections = connections_parse(arr)
    actual = find_paths(connections, ["start"], Set(String).new)
    expected = [
      ["start", "A", "b", "A", "end"],
      ["start", "A", "b", "end"],
      ["start", "A", "end"],
      ["start", "b", "A", "end"],
      ["start", "b", "end"],
    ]
    actual.should eq(expected)
  end

  it "paths sample" do
    arr = [
      "start-A",
      "start-b",
      "A-c",
      "A-b",
      "b-d",
      "A-end",
      "b-end",
    ]
    connections = connections_parse(arr)
    actual = find_paths(connections, ["start"], Set(String).new)
    expected = [
      ["start", "A", "c", "A", "b", "A", "end"],
      ["start", "A", "c", "A", "b", "end"],
      ["start", "A", "c", "A", "end"],
      ["start", "A", "b", "A", "c", "A", "end"],
      ["start", "A", "b", "A", "end"],
      ["start", "A", "b", "end"],
      ["start", "A", "end"],
      ["start", "b", "A", "c", "A", "end"],
      ["start", "b", "A", "end"],
      ["start", "b", "end"],
    ]
    actual.should eq(expected)
  end

  it "paths part one" do
    arr = [
      "start-A",
      "start-b",
      "A-c",
      "A-b",
      "b-d",
      "A-end",
      "b-end",
    ]
    actual = problem12(arr)
    actual.should eq(10)
  end

  it "paths part one sample 2" do
    arr = [
      "dc-end",
      "HN-start",
      "start-kj",
      "dc-start",
      "dc-HN",
      "LN-dc",
      "HN-end",
      "kj-sa",
      "kj-HN",
      "kj-dc",
    ]
    actual = problem12(arr)
    actual.should eq(19)
  end

  it "paths part one sample 3" do
    arr = [
      "fs-end",
      "he-DX",
      "fs-he",
      "start-DX",
      "pj-DX",
      "end-zg",
      "zg-sl",
      "zg-pj",
      "pj-he",
      "RW-he",
      "fs-DX",
      "pj-RW",
      "zg-RW",
      "start-pj",
      "he-WI",
      "zg-he",
      "pj-fs",
      "start-RW",
    ]
    actual = problem12(arr)
    actual.should eq(226)
  end

  it "paths with double visit small caves" do
    arr = [
      "start-A",
      "start-b",
      "A-b",
      "A-end",
      "b-end",
    ]
    connections = connections_parse(arr)
    actual = find_paths_with_small_caves(connections, ["start"], Hash(String, Int32).new)
    actual.size.should eq(9)

    expected = [
      ["start", "A", "b", "A", "b", "A", "end"],
      ["start", "A", "b", "A", "b", "end"],
      ["start", "A", "b", "A", "end"],
      ["start", "A", "b", "end"],
      ["start", "A", "end"],
      ["start", "b", "A", "b", "A", "end"],
      ["start", "b", "A", "b", "end"],
      ["start", "b", "A", "end"],
      ["start", "b", "end"],
    ]
    actual.should eq(expected)
  end

  it "paths sample one with double visit small caves" do
    arr = [
      "start-A",
      "start-b",
      "A-c",
      "A-b",
      "b-d",
      "A-end",
      "b-end",
    ]
    connections = connections_parse(arr)
    actual = find_paths_with_small_caves(connections, ["start"], Hash(String, Int32).new)
    actual.size.should eq(36)

    [
      ["start", "A", "b", "A", "b", "A", "end"],
      ["start", "A", "b", "A", "b", "end"],
      ["start", "A", "b", "A", "end"],
      ["start", "A", "b", "end"],
      ["start", "A", "end"],
      ["start", "b", "A", "b", "A", "end"],
      ["start", "b", "A", "b", "end"],
      ["start", "b", "A", "end"],
      ["start", "b", "end"],
    ].each do |expected|
      actual.should contain(expected)
    end
  end

  it "paths part two sample one" do
    arr = [
      "start-A",
      "start-b",
      "A-c",
      "A-b",
      "b-d",
      "A-end",
      "b-end",
    ]
    actual = problem12_part_two(arr)
    actual.should eq(36)
  end
end
