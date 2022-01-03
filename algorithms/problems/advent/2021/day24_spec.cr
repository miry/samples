require "spec"
require "./day24"

describe "Day 24" do
  describe ALU do
    it "sample" do
      input = [
        {"inp", "x", ""},
        {"mul", "x", "-1"},
      ]
      subject = ALU.new(input)
      subject.run([1_i64])
      subject.memory.should eq([0, -1, 0, 0])
    end

    it "sample three" do
      input = [
        {"inp", "z", ""},
        {"inp", "x", ""},
        {"mul", "z", "3"},
        {"eql", "z", "x"},
      ]
      subject = ALU.new(input)
      subject.run([1_i64, 3_i64])
      subject.memory.should eq([0, 3, 0, 1])

      subject.run([1_i64, 1_i64])
      subject.memory.should eq([0, 1, 0, 0])
    end

    it "div" do
      input = [
        {"inp", "z", ""},
        {"div", "z", "1"},
      ]
      subject = ALU.new(input)
      subject.run([99_i64, 3_i64])
      subject.memory.should eq([0, 0, 0, 99])
    end

    describe "cache" do
      it "sample three" do
        input = [
          {"inp", "z", ""},
          {"inp", "x", ""},
          {"mul", "z", "3"},
          {"eql", "z", "x"},
        ]
        subject = ALU.new(input)
        subject.run([1_i64, 3_i64])
        subject.memory.should eq([0, 3, 0, 1])

        # puts "===="

        subject.run([1_i64, 3_i64])
        subject.memory.should eq([0, 3, 0, 1])
      end

      it "double cache" do
        input = [
          {"inp", "w", ""},
          {"add", "z", "0"},
          {"eql", "z", "x"},
          {"inp", "w", ""},
          {"inp", "w", ""},
        ]
        subject = ALU.new(input)
        subject.run([1_i64, 2_i64, 3_i64, 5_i64])
        subject.memory.should eq([3, 0, 0, 1])

        subject.run([4_i64, 2_i64, 3_i64, 5_i64])
        subject.memory.should eq([3, 0, 0, 1])
      end
    end

    it "sample two" do
      input = [
        {"inp", "w", ""},
        {"add", "z", "w"},
        {"mod", "z", "2"},
        {"div", "w", "2"},
        {"add", "y", "w"},
        {"mod", "y", "2"},
        {"div", "w", "2"},
        {"add", "x", "w"},
        {"mod", "x", "2"},
        {"div", "w", "2"},
        {"mod", "w", "2"},
      ]
      subject = ALU.new(input)
      subject.run([7_i64])
      subject.memory.should eq([0, 1, 1, 1])
    end
  end
end
