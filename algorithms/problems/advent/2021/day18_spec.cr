require "spec"
require "./day18"

describe "Day 18" do
  describe "problem18" do
    it "check" do
      input = [
        "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]",
        "[[[5,[2,8]],4],[5,[[9,9],0]]]",
        "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]",
        "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]",
        "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]",
        "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]",
        "[[[[5,4],[7,7]],8],[[8,3],8]]",
        "[[9,3],[[9,9],[6,[4,9]]]]",
        "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]",
        "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]",
      ]
      actual = problem18(input)
      actual.should eq(4140)
    end

    it "check bigger" do
      input = [
        "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]",
        "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]",
        "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]",
        "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]",
        "[7,[5,[[3,8],[1,4]]]]",
        "[[2,[2,2]],[8,[8,1]]]",
        "[2,9]",
        "[1,[[[9,3],9],[[9,0],[0,7]]]]",
        "[[[5,[7,4]],7],1]",
        "[[[[4,2],2],6],[8,7]]",
      ]
      actual = problem18(input)
      actual.should eq(4140)
    end

    it "check small" do
      input = [
        "[1,1]",
        "[2,2]",
        "[3,3]",
        "[4,4]",
      ]
      actual = problem18(input)
      actual.should eq(4140)
    end

    it "check small two" do
      input = [
        "[1,1]",
        "[2,2]",
        "[3,3]",
        "[4,4]",
        "[5,5]",
      ]
      actual = problem18(input)
      actual.should eq(4140)
    end
  end

  describe "problem18_part_two" do
    it "check" do
      input = [
        "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]",
        "[[[5,[2,8]],4],[5,[[9,9],0]]]",
        "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]",
        "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]",
        "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]",
        "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]",
        "[[[[5,4],[7,7]],8],[[8,3],8]]",
        "[[9,3],[[9,9],[6,[4,9]]]]",
        "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]",
        "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]",
      ]
      actual = problem18_part_two(input)
      actual.should eq(3993)
    end
  end

  describe SnailfishNumber do
    describe ".parse" do
      it "extract literals" do
        actual = SnailfishNumber.parse("[1,2]")
        actual.left.should eq(1)
        actual.right.should eq(2)
      end

      it "understands include pair" do
        actual = SnailfishNumber.parse("[[1,2],3]")
        actual.left.should be_a(SnailfishNumber)
        actual.right.should eq(3)

        actual = actual.left.as(SnailfishNumber)
        actual.left.should eq(1)
        actual.right.should eq(2)
      end

      it "understands include pair" do
        actual = SnailfishNumber.parse("[[1,2],[3,4]]")
        actual.left.should be_a(SnailfishNumber)
        actual.right.should be_a(SnailfishNumber)

        actual = actual.right.as(SnailfishNumber)
        actual.left.should eq(3)
        actual.right.should eq(4)
      end

      it "deep include pairs" do
        actual = SnailfishNumber.parse("[[[[[9,8],1],2],3],4]")
        actual.left.should be_a(SnailfishNumber)
        actual.right.should eq(4)
        actual.to_s.should eq("[[[[[9,8],1],2],3],4]")
      end
    end

    describe ".extract_pair" do
      it "returns first pair" do
        actual = SnailfishNumber.extract_pair("[[1,2],3]")
        actual.should eq("[[1,2],3]")
      end

      it "returns first closed pair" do
        actual = SnailfishNumber.extract_pair("[1,2],3]")
        actual.should eq("[1,2]")
      end
    end

    describe "#add" do
      it "combine pairs" do
        actual = SnailfishNumber.parse("[1,2]") + SnailfishNumber.parse("[[3,4],5]")
        actual.to_s.should eq("[[1,2],[[3,4],5]]")
      end

      it "reduces result" do
        actual = SnailfishNumber.parse("[[[[4,3],4],4],[7,[[8,4],9]]]") + SnailfishNumber.parse("[1,1]")
        actual.to_s.should eq("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")
      end

      it "sample two" do
        a1 = SnailfishNumber.parse("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]")
        a2 = SnailfishNumber.parse("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")
        actual = a1 + a2
        actual.to_s.should eq("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")
      end

      it "sample three" do
        a1 = SnailfishNumber.parse("[[[[1,1],[2,2]],[3,3]],[4,4]]")
        a2 = SnailfishNumber.parse("[5,5]")
        actual = a1 + a2
        actual.to_s.should eq("[[[[3,0],[5,3]],[4,4]],[5,5]]")
      end

      it "sample three" do
        a1 = SnailfishNumber.parse("[[[[3,0],[5,3]],[4,4]],[5,5]]")
        a2 = SnailfishNumber.parse("[6,6]")
        actual = a1 + a2
        actual.to_s.should eq("[[[[5,0],[7,4]],[5,5]],[6,6]]")
      end

      it "sample four" do
        a1 = SnailfishNumber.parse("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]")
        a2 = SnailfishNumber.parse("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")
        actual = a1 + a2
        actual.to_s.should eq("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")
      end

      it "sample five" do
        a1 = SnailfishNumber.parse("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]")
        a2 = SnailfishNumber.parse("[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]")
        actual = a1 + a2
        actual.to_s.should eq("[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]")
      end

      it "sample six" do
        a1 = SnailfishNumber.parse("[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]")
        a2 = SnailfishNumber.parse("[[[5,[7,4]],7],1]")
        actual = a1 + a2
        actual.to_s.should eq("[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]")
      end

      it "sample six" do
        a1 = SnailfishNumber.parse("[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]")
        a2 = SnailfishNumber.parse("[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]")
        actual = a1 + a2
        actual.to_s.should eq("[[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]]")
      end

      it "investigate reduce" do
        subject = SnailfishNumber.parse("[[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[0,[14,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[14,0],[[13,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[14,13],[0,[8,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[14,13],[8,0]],[[[15,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[14,13],[8,15]],[[0,[12,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[14,13],[8,15]],[[12,0],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[14,13],[8,15]],[[12,5],[0,[10,6]]]],[[[5,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[14,13],[8,15]],[[12,5],[10,0]]],[[[11,[7,4]],7],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[14,13],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!.should be_nil
        subject.to_s.should eq("[[[[14,13],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")

        subject.split!
        subject.to_s.should eq("[[[[[7,7],13],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")

        subject.explode!
        subject.to_s.should eq("[[[[0,20],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!.should be_nil
        subject.to_s.should eq("[[[[0,20],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")

        subject.split!
        subject.to_s.should eq("[[[[0,[10,10]],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[10,0],[18,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!.should be_nil

        subject.split!
        subject.to_s.should eq("[[[[[5,5],0],[18,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[0,5],[18,15]],[[12,5],[10,0]]],[[[18,0],11],1]]")

        subject.split!
        subject.to_s.should eq("[[[[0,5],[[9,9],15]],[[12,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[0,14],[0,24]],[[12,5],[10,0]]],[[[18,0],11],1]]")

        subject.split!
        subject.to_s.should eq("[[[[0,[7,7]],[0,24]],[[12,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[7,0],[7,24]],[[12,5],[10,0]]],[[[18,0],11],1]]")

        subject.split!
        subject.to_s.should eq("[[[[7,0],[7,[12,12]]],[[12,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[7,0],[19,0]],[[24,5],[10,0]]],[[[18,0],11],1]]")

        subject.split!
        subject.to_s.should eq("[[[[7,0],[[9,10],0]],[[24,5],[10,0]]],[[[18,0],11],1]]")
        subject.explode!
        subject.to_s.should eq("[[[[7,9],[0,10]],[[24,5],[10,0]]],[[[18,0],11],1]]")
      end
    end

    describe "#explode!" do
      it "removes pair from left" do
        subject = SnailfishNumber.parse("[[[[[9,8],1],2],3],4]")
        subject.explode!
        subject.to_s.should eq("[[[[0,9],2],3],4]")
      end

      it "removes pair from right" do
        subject = SnailfishNumber.parse("[7,[6,[5,[4,[3,2]]]]]")
        subject.explode!
        subject.to_s.should eq("[7,[6,[5,[7,0]]]]")
      end

      it "removes pair from middle" do
        subject = SnailfishNumber.parse("[[6,[5,[4,[3,2]]]],1]")
        subject.explode!
        subject.to_s.should eq("[[6,[5,[7,0]]],3]")
      end

      it "removes pair from middle with next branch" do
        subject = SnailfishNumber.parse("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")
        subject.explode!
        subject.to_s.should eq("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")
      end

      it "removes pair from middle with next branch second iteration" do
        subject = SnailfishNumber.parse("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")
        subject.explode!
        subject.to_s.should eq("[[3,[2,[8,0]]],[9,[5,[7,0]]]]")
      end

      it "removes pair from left in middle" do
        subject = SnailfishNumber.parse("[[9,[5,[4,[3,2]]]],[3,[2,[8,0]]]]")
        subject.explode!
        subject.to_s.should eq("[[9,[5,[7,0]]],[5,[2,[8,0]]]]")
      end

      it "removes pair from left cell in middle" do
        subject = SnailfishNumber.parse("[[9,[5,[[3,2],4]]],[3,[2,[8,0]]]]")
        subject.explode!
        subject.to_s.should eq("[[9,[8,[0,6]]],[3,[2,[8,0]]]]")
      end

      it "sample from add" do
        subject = SnailfishNumber.parse("[[[[[1,1],[2,2]],[3,3]],[4,4]],[5,5]]")
        subject.explode!
        subject.to_s.should eq("[[[[0,[3,2]],[3,3]],[4,4]],[5,5]]")
        subject.explode!
        subject.to_s.should eq("[[[[3,0],[5,3]],[4,4]],[5,5]]")
      end
    end

    describe "#split!" do
      it "split sample 1" do
        subject = SnailfishNumber.parse("[[[[0,7],4],[15,[0,13]]],[1,1]]")
        subject.split!
        subject.to_s.should eq("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")
      end

      it "split sample 2" do
        subject = SnailfishNumber.parse("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")
        subject.split!
        subject.to_s.should eq("[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]")
      end

      it "split sample 3" do
        subject = SnailfishNumber.parse("[[[[14,13],[8,0]],[[[15,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        subject.split!
        subject.to_s.should eq("[[[[[7,7],13],[8,0]],[[[15,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
      end

      it "splits by edge left" do
        subject = SnailfishNumber.parse("[[[[7,7],[7,7]],[[0,8],[7,7]]],[[[26,0],11],1]]")
        subject.split!
        subject.to_s.should eq("[[[[7,7],[7,7]],[[0,8],[7,7]]],[[[[13,13],0],11],1]]")
      end
    end

    describe "#magnitude" do
      it "sample one" do
        actual = SnailfishNumber.parse("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")
        actual.magnitude.should eq(4140)
      end

      it "sample two" do
        actual = SnailfishNumber.parse("[[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]]")
        actual.magnitude.should eq(3993)
      end
    end

    describe "#reduce" do
      it "reduces sample" do
        subject = SnailfishNumber.parse("[[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]")
        actual = subject.reduce
        actual.size.should eq(104)
        expected = [
          "[[[[0,[14,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]",
          "[[[[14,0],[[13,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]",
          "[[[[14,13],[0,[8,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]",
          "[[[[14,13],[8,0]],[[[15,7],[5,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]",
          "[[[[14,13],[8,15]],[[0,[12,0]],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]",
          "[[[[14,13],[8,15]],[[12,0],[[5,5],[5,6]]]],[[[5,[7,4]],7],1]]",
          "[[[[14,13],[8,15]],[[12,5],[0,[10,6]]]],[[[5,[7,4]],7],1]]",
          "[[[[14,13],[8,15]],[[12,5],[10,0]]],[[[11,[7,4]],7],1]]",
          "[[[[14,13],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[[7,7],13],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[0,20],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[0,[10,10]],[8,15]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[10,0],[18,15]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[[5,5],0],[18,15]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[0,5],[18,15]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[0,5],[[9,9],15]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[0,14],[0,24]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[0,[7,7]],[0,24]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,0],[7,24]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,0],[7,[12,12]]],[[12,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,0],[19,0]],[[24,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,0],[[9,10],0]],[[24,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,9],[0,10]],[[24,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,9],[0,[5,5]]],[[24,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,9],[5,0]],[[29,5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,9],[5,0]],[[[14,15],5],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,9],[5,14]],[[0,20],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,9],[5,[7,7]]],[[0,20],[10,0]]],[[[18,0],11],1]]",
          "[[[[7,9],[12,0]],[[7,20],[10,0]]],[[[18,0],11],1]]",
        ]

        puts actual.join("\n")
        expected.each_with_index do |r, i|
          r.should eq(actual[i])
        end
      end
    end
  end
end
