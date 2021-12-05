require "spec"
require "./utils"

describe "Utils" do
  describe "matrix" do
    it "print matrix with columns" do
      arr = [
        "1.1....11.",
        ".111...2..",
        "..2.1.111.",
        "...1.2.2..",
        ".112313211",
        "...1.2....",
        "..1...1...",
        ".1.....1..",
        "1.......1.",
        "222111....",
      ]
      io = IO::Memory.new
      print_matrix(arr.map(&.chars), output: io)
      io.to_s.rchop.should eq(<<-EOS)
      1  .  1  .  .  .  .  1  1  .  
      .  1  1  1  .  .  .  2  .  .  
      .  .  2  .  1  .  1  1  1  .  
      .  .  .  1  .  2  .  2  .  .  
      .  1  1  2  3  1  3  2  1  1  
      .  .  .  1  .  2  .  .  .  .  
      .  .  1  .  .  .  1  .  .  .  
      .  1  .  .  .  .  .  1  .  .  
      1  .  .  .  .  .  .  .  1  .  
      2  2  2  1  1  1  .  .  .  .  
      EOS
    end

    it "print matrix with custom format" do
      arr = [
        "22 13 17 11  0".strip.split(/\s+/),
        " 8  2 23  4 24".strip.split(/\s+/),
        "21  9 14 16  7".strip.split(/\s+/),
        " 6 10  3 18  5".strip.split(/\s+/),
        " 1 12 20 15 19".strip.split(/\s+/),
      ]
      io = IO::Memory.new
      print_matrix(arr, format_cell: "%2s", sep: " ", output: io)
      io.to_s.should eq("22 13 17 11  0\n 8  2 23  4 24\n21  9 14 16  7\n 6 10  3 18  5\n 1 12 20 15 19\n")
    end

    it "print matrix modify cell content from callback" do
      arr = [
        "22 13 17 11  0".strip.split(/\s+/).map(&.to_i32),
        " 8  2 23  4 24".strip.split(/\s+/).map(&.to_i32),
        "21  9 14 16  7".strip.split(/\s+/).map(&.to_i32),
        " 6 10  3 18  5".strip.split(/\s+/).map(&.to_i32),
        " 1 12 20 15 19".strip.split(/\s+/).map(&.to_i32),
      ]
      played = [7, 4, 9, 5, 11, 17]
      io = IO::Memory.new
      print_matrix(arr, format_cell: "%3s", sep: " ", output: io) do |cell|
        played.includes?(cell) ? "*#{cell}" : cell.to_s
      end
      io.to_s.rchop.should eq(<<-EOS)
       22  13 *17 *11   0
        8   2  23  *4  24
       21  *9  14  16  *7
        6  10   3  18  *5
        1  12  20  15  19
      EOS
    end
  end
end
