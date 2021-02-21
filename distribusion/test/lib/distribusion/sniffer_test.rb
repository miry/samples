# frozen_string_literal: true

require "test_helper"

class SnifferTest < Minitest::Test
  def test_initilize
    @sniffer = Distribusion::Sniffer.new(
      start_node: "a",
      end_node: "b",
      time: "2018-08-08 12:34:11",
      time_zone: "UTC",
      duration_in_milliseconds: 1000
    )
  end
end
