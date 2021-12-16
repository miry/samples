require "spec"
require "./day16"

describe "Day 16" do
  describe ".convert_hex_to_bits" do
    it "tiny size" do
      bits = Packet.convert_hex_to_bits("D2FE28")
      bits.join.should eq("110 100 10111 11110 00101 000".delete(" "))
    end

    it "small size" do
      bits = Packet.convert_hex_to_bits("38006F45291200")
      bits.join.should eq("001 110 0 000000000011011 1101000101001010010001001000000000".delete(" "))
    end

    it "small size example two" do
      bits = Packet.convert_hex_to_bits("EE00D40C823060")
      bits.size.should eq(56)
      bits.join.should eq("111 011 1 00000000011 01010000001100100000100011000001100000".delete(" "))
    end

    it "example three" do
      bits = Packet.convert_hex_to_bits("8A004A801A8002F478")
      bits.size.should eq(72)
      bits.join.should eq("100 010 1 00000000001 001010100000000001101010000000000000101111010001111000".delete(" "))
    end
  end

  describe ".parse" do
    it "single packet of type 4" do
      actual = Packet.parse("D2FE28").not_nil!
      actual.type_id.should eq(4)
      actual.version.should eq(6)
      actual.payload.should eq([['0', '1', '1', '1'], ['1', '1', '1', '0'], ['0', '1', '0', '1']])
      actual.size.should eq(21)
      actual.value.should eq(2021)
    end

    it "operator with label" do
      actual = Packet.parse("38006F45291200").not_nil!
      actual.type_id.should eq(6)
      actual.version.should eq(1)
      actual.length_type_id.should eq('0')
      actual.subpacket_bits_size.should eq(27)
      actual.payload[0].size.should eq(11)
      actual.payload[1].size.should eq(16)
      actual.size.should eq(49)
    end

    it "operator with type id 1" do
      actual = Packet.parse("EE00D40C823060").not_nil!.not_nil!
      actual.type_id.should eq(3)
      actual.version.should eq(7)
      actual.size.should eq(51)
      actual.length_type_id.should eq('1')
      actual.sub_packets_count.should eq(3)
      actual.subpacket_bits_size.should eq(33)
      actual.payload.size.should eq(3)
      actual.payload.map(&.size).should eq([11, 11, 11])
      actual.payload[0].join.should eq("01010000001")
      actual.payload[1].join.should eq("10010000010")
      actual.payload[2].join.should eq("00110000011")
    end

    it "operator with type id 1 length 11 bits sample two" do
      actual = Packet.parse("8A004A801A8002F478").not_nil!
      actual.type_id.should eq(2)
      actual.version.should eq(4)
      actual.length_type_id.should eq('1')
      actual.sub_packets_count.should eq(1)
      actual.subpacket_bits_size.should eq(51) # single packet
      actual.size.should eq(69)
      actual.payload.size.should eq(1)
      actual.payload[0].size.should eq(51)
      actual.payload[0].join.should eq("001010100000000001101010000000000000101111010001111")
    end
  end

  describe ".process" do
    it "process sub packet" do
      bits = "010 100 00001 100100000100011000001100000".delete(" ").chars
      actual = Packet.process(bits).not_nil!
      actual.version.should eq(2)
      actual.type_id.should eq(4)
      actual.size.should eq(11)
    end

    it "process sub packet operator" do
      bits = "001 010 1 00000000001 101010000000000000101111010001111000".delete(" ").chars
      actual = Packet.process(bits).not_nil!
      actual.version.should eq(1)
      actual.type_id.should eq(2)
      actual.size.should eq(51)
      actual.payload.size.should eq(1)
      actual.payload[0].size.should eq(33)
    end
  end

  describe "#packets" do
    it "for type four" do
      subject = Packet.parse("D2FE28").not_nil!
      actual = subject.packets
      actual.size.should eq(0)
    end

    it "packets for 38006F45291200 type id 0" do
      packet = Packet.parse("38006F45291200").not_nil!
      actual = packet.packets
      actual.size.should eq(2)
      actual.map(&.value).should eq([10, 20])
    end

    it "packets for EE00D40C823060 type id 1" do
      packet = Packet.parse("EE00D40C823060").not_nil!
      actual = packet.packets
      actual.size.should eq(3)
      actual.map(&.value).should eq([1, 2, 3])
    end

    it "multi operator" do
      # 8A004A801A8002F478 represents an operator packet (version 4) which contains an operator packet (version 1) which contains an operator packet (version 5) which contains a literal value (version 6); this packet has a version sum of 16.
      packet = Packet.parse("8A004A801A8002F478").not_nil!
      packet.version.should eq(4)
      packet.size.should eq(69)

      actual = packet.packets
      actual.size.should eq(1)
      packet = actual[0]
      packet.version.should eq(1)

      actual = packet.packets
      actual.size.should eq(1)
      packet = actual[0]
      packet.version.should eq(5)

      actual = packet.packets
      actual.size.should eq(1)
      packet = actual[0]
      packet.version.should eq(6)
    end
  end

  describe "#value" do
    it "sums of sub packets value" do
      subject = Packet.parse("C200B40A82")
      subject.type_id.should eq(0)
      subject.value.should eq(3)
    end

    it "product of sub packets value" do
      subject = Packet.parse("04005AC33890")
      subject.type_id.should eq(1)
      subject.value.should eq(54)
    end

    it "finds min of sub packets value" do
      subject = Packet.parse("880086C3E88112")
      subject.type_id.should eq(2)
      subject.value.should eq(7)
    end

    it "finds max of sub packets value" do
      subject = Packet.parse("CE00C43D881120")
      subject.type_id.should eq(3)
      subject.value.should eq(9)
    end

    it "compare > of sub packets value" do
      subject = Packet.parse("F600BC2D8F")
      subject.type_id.should eq(5)
      subject.value.should eq(0)
    end

    it "compare < of sub packets value" do
      subject = Packet.parse("D8005AC2A8F0")
      subject.type_id.should eq(6)
      subject.value.should eq(1)
    end

    it "compares == of sub packets value" do
      subject = Packet.parse("9C005AC2F8F0")
      subject.type_id.should eq(7)
      subject.value.should eq(0)
    end

    it "sub values" do
      subject = Packet.parse("9C0141080250320F1802104A08")
      subject.type_id.should eq(7)
      subject.value.should eq(1)
    end
  end

  describe "problem16" do
    it "process 8A004A801A8002F478" do
      problem16("8A004A801A8002F478").should eq(16)
    end
    it "process 620080001611562C8802118E34" do
      problem16("620080001611562C8802118E34").should eq(12)
    end
    it "process C0015000016115A2E0802F182340" do
      problem16("C0015000016115A2E0802F182340").should eq(23)
    end
    it "process A0016C880162017C3686B18A3D4780" do
      problem16("A0016C880162017C3686B18A3D4780").should eq(31)
    end
  end
end
