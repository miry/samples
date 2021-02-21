# frozen_string_literal: true

require "test_helper"

class RouteTest < Minitest::Test
  include Distribusion

  def test_initialization
    @route = Route.new(source: :sentinels,
                       start_node: "alpha",
                       end_node: "delta",
                       start_time: "",
                       end_time: "")
  end
end
