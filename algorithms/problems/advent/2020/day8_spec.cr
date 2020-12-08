require "spec"
require "./day8"

describe "Day 8" do
  describe Gameboy do
    describe ".load" do
      it "loads programm in memory" do
        subject = Gameboy.load(["nop +0", "nop +2"])
        subject.should_not be_nil
      end

      it "boot code has 2 instructions" do
        subject = Gameboy.load(["nop +0", "nop +2"])
        subject.boot_code.size.should eq(2)
      end
    end

    describe ".new" do
      it "accumulator is zero" do
        subject = Gameboy.new([GameboyCommand.new("nop", 0)])
        subject.accumulator.should eq(0)
      end

      it "ipc is zero" do
        subject = Gameboy.new([GameboyCommand.new("nop", 0)])
        subject.ipc.should eq(0)
      end
    end

    describe "#step" do
      it "incremenets ipc on  each step" do
        subject = Gameboy.new([
          GameboyCommand.new("nop", 0),
          GameboyCommand.new("nop", 0),
        ])
        subject.step
        subject.ipc.should eq(1)
        subject.step
        subject.ipc.should eq(2)
      end

      describe "nop" do
        it "does not change accu" do
          subject = Gameboy.new([GameboyCommand.new("nop", 0)])
          subject.step
          subject.accumulator.should eq(0)
        end
      end

      describe "acc" do
        it "increment acc" do
          subject = Gameboy.new([
            GameboyCommand.new("acc", 1),
            GameboyCommand.new("acc", 2),
            GameboyCommand.new("acc", -5),
          ])
          subject.step
          subject.accumulator.should eq(1)
          subject.step
          subject.accumulator.should eq(3)
          subject.step
          subject.accumulator.should eq(-2)
        end
      end

      describe "jmp" do
        it "does not change accu" do
          subject = Gameboy.new([
            GameboyCommand.new("jmp", 1),
            GameboyCommand.new("jmp", 2),
            GameboyCommand.new("acc", -5),
            GameboyCommand.new("nop", -5),
          ])
          subject.ipc.should eq(0)
          subject.step
          subject.ipc.should eq(1)
          subject.step
          subject.ipc.should eq(3)
          subject.step
          subject.ipc.should eq(4)
          subject.accumulator.should eq(0)
        end
      end
    end

    describe "#detect_loop" do
      it "sample loop" do
        subject = Gameboy.new([
          GameboyCommand.new("jmp", 0),
        ])
        subject.ipc.should eq(0)
        subject.step
        subject.ipc.should eq(0)
      end

      it "returns last ipc before loop" do
        subject = Gameboy.new([
          GameboyCommand.new("jmp", 0),
        ])
        subject.detect_loop.should eq([0])
      end

      it "calcuate acc" do
        subject = Gameboy.new([
          GameboyCommand.new("acc", 2),
          GameboyCommand.new("jmp", -1),
        ])
        subject.detect_loop.should eq([1])
        subject.accumulator.should eq(2)
      end
    end
  end

  describe GameboyCommand do
    describe ".parse" do
      it "is not nil" do
        subject = GameboyCommand.parse("nop +1")
        subject.should_not be_nil
      end

      it "extract command nop" do
        subject = GameboyCommand.parse("nop +1")
        subject.operation.should eq("nop")
      end

      it "extract argument nop" do
        subject = GameboyCommand.parse("nop +1")
        subject.argument.should eq(1)
      end
    end

    describe "#swap" do
      it "replace nop with jmp" do
        subject = GameboyCommand.new("nop", 1)
        actual = subject.swap
        actual.operation.should eq("jmp")
      end

      it "replace jmp with nop" do
        subject = GameboyCommand.new("jmp", 1)
        actual = subject.swap
        actual.operation.should eq("nop")
      end
    end
  end
end
