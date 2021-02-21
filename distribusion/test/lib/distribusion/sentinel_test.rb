# frozen_string_literal: true

require "test_helper"

class SentinelTest < Minitest::Test
  def setup
    @sentinel = Distribusion::Sentinel.new(route_id: "1",
                                           node: "alpha",
                                           index: "0",
                                           time: "2030-12-31T22:00:01+09:00")
  end

  def test_that_sential_has_route_id
    assert_equal 1, @sentinel.route_id
  end

  def test_that_sential_has_node
    assert_equal "alpha", @sentinel.node
  end

  def test_that_sential_has_index
    assert_equal 0, @sentinel.index
  end

  def test_that_sentinel_has_custom_iso_time
    # https://en.wikipedia.org/wiki/ISO_8601 2018-08-13T17:36:50+00:00, 2018-08-13T17:36:50Z, 20180813T173650Z
    assert_equal "2030-12-31T13:00:01", @sentinel.time
  end
end
