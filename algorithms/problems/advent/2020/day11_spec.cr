require "spec"
require "./day11"

def plan
  [
    "L.LL.LL.LL".chars,
    "LLLLLLL.LL".chars,
    "L.L.L..L..".chars,
    "LLLL.LL.LL".chars,
    "L.LL.LL.LL".chars,
    "L.LLLLL.LL".chars,
    "..L.L.....".chars,
    "LLLLLLLLLL".chars,
    "L.LLLLLL.L".chars,
    "L.LLLLL.LL".chars,
  ]
end

describe "Day 11" do
  describe SeatingSystem do
    it "initialize with a map" do
      subject = SeatingSystem.new(plan)
      subject.should_not be_nil
    end

    it "fill seats first round" do
      subject = SeatingSystem.new(plan)
      subject.round
      subject.plan.should eq(
        [
          "#.##.##.##".chars,
          "#######.##".chars,
          "#.#.#..#..".chars,
          "####.##.##".chars,
          "#.##.##.##".chars,
          "#.#####.##".chars,
          "..#.#.....".chars,
          "##########".chars,
          "#.######.#".chars,
          "#.#####.##".chars,
        ]
      )
    end

    it "fill seats first round" do
      subject = SeatingSystem.new(plan[0..1])
      subject.round
      subject.plan.should eq(
        [
          "#.##.##.##".chars,
          "#######.##".chars,
        ]
      )
      subject.round
      subject.plan.should eq(
        [
          "#.LL.L#.##".chars,
          "#LLLLL#.##".chars,
        ]
      )
    end

    it "fill seats second round full" do
      subject = SeatingSystem.new(plan)
      subject.round
      subject.round
      subject.plan.should eq(
        [
          "#.LL.L#.##".chars,
          "#LLLLLL.L#".chars,
          "L.L.L..L..".chars,
          "#LLL.LL.L#".chars,
          "#.LL.LL.LL".chars,
          "#.LLLL#.##".chars,
          "..L.L.....".chars,
          "#LLLLLLLL#".chars,
          "#.LLLLLL.L".chars,
          "#.#LLLL.##".chars,
        ]
      )
    end

    it "fill seats third round full" do
      subject = SeatingSystem.new(plan)
      subject.round
      subject.round
      subject.round
      subject.plan.should eq(
        [
          "#.##.L#.##".chars,
          "#L###LL.L#".chars,
          "L.#.#..#..".chars,
          "#L##.##.L#".chars,
          "#.##.LL.LL".chars,
          "#.###L#.##".chars,
          "..#.#.....".chars,
          "#L######L#".chars,
          "#.LL###L.L".chars,
          "#.#L###.##".chars,
        ]
      )
    end

    it "fill seats four rounds full" do
      subject = SeatingSystem.new(plan)
      subject.round
      subject.round
      subject.round
      subject.round
      subject.plan.should eq(
        [
          "#.#L.L#.##".chars,
          "#LLL#LL.L#".chars,
          "L.L.L..#..".chars,
          "#LLL.##.L#".chars,
          "#.LL.LL.LL".chars,
          "#.LL#L#.##".chars,
          "..L.L.....".chars,
          "#L#LLLL#L#".chars,
          "#.LLLLLL.L".chars,
          "#.#L#L#.##".chars,
        ]
      )
    end

    it "fill seats five rounds full" do
      subject = SeatingSystem.new(plan)
      subject.round
      subject.round
      subject.round
      subject.round
      subject.round
      subject.plan.should eq(
        [
          "#.#L.L#.##".chars,
          "#LLL#LL.L#".chars,
          "L.#.L..#..".chars,
          "#L##.##.L#".chars,
          "#.#L.LL.LL".chars,
          "#.#L#L#.##".chars,
          "..L.L.....".chars,
          "#L#L##L#L#".chars,
          "#.LLLLLL.L".chars,
          "#.#L#L#.##".chars,
        ]
      )
    end

    it "fill seats size rounds full" do
      subject = SeatingSystem.new(plan)
      5.times do |i|
        subject.round.should eq(true)
      end
      subject.round.should eq(false)
    end

    it "stablized rounds to fill seats" do
      subject = SeatingSystem.new(plan)
      actual = subject.stabalize_rounds
      actual.should eq(37)
    end

    it "fill seats round2" do
      subject = SeatingSystem.new(plan)
      subject.round2
      subject.plan.should eq(
        [
          "#.##.##.##".chars,
          "#######.##".chars,
          "#.#.#..#..".chars,
          "####.##.##".chars,
          "#.##.##.##".chars,
          "#.#####.##".chars,
          "..#.#.....".chars,
          "##########".chars,
          "#.######.#".chars,
          "#.#####.##".chars,
        ]
      )

      subject.round2
      subject.plan.should eq(
        [
          "#.LL.LL.L#".chars,
          "#LLLLLL.LL".chars,
          "L.L.L..L..".chars,
          "LLLL.LL.LL".chars,
          "L.LL.LL.LL".chars,
          "L.LLLLL.LL".chars,
          "..L.L.....".chars,
          "LLLLLLLLL#".chars,
          "#.LLLLLL.L".chars,
          "#.LLLLL.L#".chars,
        ]
      )
    end

    it "fill seats round2" do
      subject = SeatingSystem.new(
        [
          ".......#.".chars,
          "...#.....".chars,
          ".#.......".chars,
          ".........".chars,
          "..#L....#".chars,
          "....#....".chars,
          ".........".chars,
          "#........".chars,
          "...#.....".chars,
        ] of Array(Char)
      )
      actual = subject.adjacented2(3, 4)
      actual.should eq([false, false, false, false, false, false, false, false])
    end

    it "fill seat direction empty" do
      subject = SeatingSystem.new(
        [
          ".......#.".chars,
          "...#.....".chars,
          ".#.......".chars,
          ".........".chars,
          "..#L....#".chars,
          "....#....".chars,
          ".........".chars,
          "#........".chars,
          "...#.....".chars,
        ] of Array(Char)
      )
      subject.plan[3][3].should eq('.')
      actual = subject.seat_direction(3, 3, -1, 0)
      actual.should eq('.')
    end

    it "fill seat direction occp" do
      subject = SeatingSystem.new(
        [
          ".......#.".chars,
          "...#.....".chars,
          ".#.......".chars,
          ".........".chars,
          "..#L....#".chars,
          "....#....".chars,
          ".........".chars,
          "#........".chars,
          "...#.....".chars,
        ] of Array(Char)
      )
      subject.plan[4][3].should eq('L')
      actual = subject.seat_direction(3, 4, -1, 0)
      actual.should eq('#')
    end
  end
end
