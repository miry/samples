require "spec"
require "./day_eight"

describe "Day 8" do
  it "has layers" do
    subject = NetworkImage.new(3, 2, "123456789012")
    subject.layers.should eq([['1', '2', '3', '4', '5', '6'], ['7', '8', '9', '0', '1', '2']] of Array(Char))
  end

  it "layer with fewest 0" do
    subject = NetworkImage.new(3, 2, "123456789012")
    subject.layer_with_fewest_null.should eq(['1', '2', '3', '4', '5', '6'] of Char)
  end

  it "layers returns number of 1 multiple by number of 2" do
    subject = NetworkImage.new(3, 2, "123456789012")
    subject.seed(['1', '1', '2', '2', '3', '4', '3', '4', '3', '1']).should eq(6)
  end

  describe "Layer" do
    it "print image" do
      subject = Layer.new(3, 2, ['1', '1', '2', '2', '0', '0'])
      subject.print
    end

    it "mask with layer" do
      subject = Layer.new(3, 2, ['1', '1', '2', '2', '0', '0'])
      other = Layer.new(3, 2, ['0', '0', '0', '0', '1', '1'])
      actual = subject.mask(other)
      actual.pixels.should eq(['1', '1', '0', '0', '0', '0'] of Char)
    end
  end
end
