require "spec"
require "./day_four"

describe "Day 4" do
  describe Passport do
    describe ".parse" do
      it "parse string with pasposrt data" do
        subject = Passport.parse("byr:1933 hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:0952910416")
        actual = subject.data
        expected = {"byr" => "1933", "hcl" => "#733820", "hgt" => "165cm", "eyr" => "2027", "iyr" => "2018", "ecl" => "oth", "pid" => "0952910416"}
        actual.should eq(expected)
      end

      it "parse with leading space" do
        subject = Passport.parse(" byr:1933 hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:0952910416")
        actual = subject.data
        expected = {"byr" => "1933", "hcl" => "#733820", "hgt" => "165cm", "eyr" => "2027", "iyr" => "2018", "ecl" => "oth", "pid" => "0952910416"}
        actual.should eq(expected)
      end
    end

    describe "#has_required_fields?" do
      it "has all required fileds without cid" do
        subject = Passport.parse("byr:1933 hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:0952910416")
        subject.has_required_fields?.should eq(true)
      end

      it "has all required fileds with cid" do
        subject = Passport.parse("byr:1933 hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:0952910416 cid:12312")
        subject.has_required_fields?.should eq(true)
      end

      it "missing byr" do
        subject = Passport.parse("hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:0952910416 cid:12312")
        subject.has_required_fields?.should eq(false)
      end
    end

    describe "#valid?" do
      it "valid passport" do
        subject = Passport.parse("byr:1933 hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:095291041 cid:12312")
        subject.valid?.should eq(true)
      end

      it "validate invalid byr field" do
        subject = Passport.parse("byr:1900 hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:095291041 cid:12312")
        subject.valid?.should eq(false)
      end

      it "validate invalid pid field" do
        subject = Passport.parse("byr:1933 hcl:#733820 hgt:165cm eyr:2027 iyr:2018 ecl:oth pid:1234567890 cid:12312")
        subject.valid?.should eq(false)
      end
    end
  end
end
