require "spec"
require "./day_two"

describe "Day 2" do
  describe Password do
    describe ".parse" do
      it "initialize object with string" do
        subject = Password.parse("1-3 a: abcde")
        subject.min.should eq(1)
        subject.max.should eq(3)
        subject.letter.should eq('a')
        subject.password.should eq("abcde")
      end

      it "initialize object with another sample string" do
        subject = Password.parse("1-3 b: cdefg")
        subject.min.should eq(1)
        subject.max.should eq(3)
        subject.letter.should eq('b')
        subject.password.should eq("cdefg")
      end

      it "parses empty string" do
        expect_raises(NilAssertionError) do
          Password.parse("")
        end
      end

      it "parses non valid string" do
        expect_raises(NilAssertionError) do
          Password.parse("a-b world the great")
        end
      end
    end

    describe "#valid?" do
      it "validates the password policy success" do
        subject = Password.new(1.to_i64, 3.to_i64, 'a', "abcde")
        subject.valid?.should be_true
      end

      it "validates the password policy invalid" do
        subject = Password.new(1.to_i64, 3.to_i64, 'b', "cdefg")
        subject.valid?.should be_false
      end

      it "validates the password second policy success" do
        subject = Password.new(1.to_i64, 3.to_i64, 'a', "abcde")
        subject.valid?(2).should be_true
      end

      it "validates the password second policy invalid" do
        subject = Password.new(1.to_i64, 3.to_i64, 'b', "cdefg")
        subject.valid?(2).should be_false
      end

      it "validates the password second policy invalid third" do
        subject = Password.new(2.to_i64, 9.to_i64, 'c', "ccccccccc")
        subject.valid?(2).should be_false
      end
    end
  end
end
