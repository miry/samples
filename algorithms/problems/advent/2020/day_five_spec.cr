require "spec"
require "./day_five"

describe "Day 5" do
  describe BoardSeat do
    describe ".parse" do
      it "parse string with seats" do
        subject = BoardSeat.parse("BFFFBBFRRR")
        subject.should_not be_nil
      end

      it "parse string with seats" do
        subject = BoardSeat.parse("FBFBBFFRLR")
        subject.seat_id.should eq(357)
      end

      it "parses first sample and get 567" do
        subject = BoardSeat.parse("BFFFBBFRRR")
        subject.seat_id.should eq(567)
      end

      it "parses first sample and get 119" do
        subject = BoardSeat.parse("FFFBBBFRRR")
        subject.seat_id.should eq(119)
      end

      it "parses first sample and get 820" do
        subject = BoardSeat.parse("BBFFBBFRLL")
        subject.seat_id.should eq(820)
      end
    end
  end
end
