# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class DriverSentinelTest < Minitest::Test
  include Distribusion

  def setup
    @driver = Distribusion::Driver::Sentinel.new(passphrase: 'test')
  end

  def test_importer_sentinels_parse_empty
    sentinels = @driver.parse({})[:routes]
    assert_equal 0, sentinels.size
  end

  def test_importer_sentinels_parse_nil
    sentinels = @driver.parse(nil)[:routes]
    assert_equal 0, sentinels.size
  end

  def test_importer_sentinels_parse_sample
    sentinels = @driver.parse(routes: sentinels_routes_csv)[:routes]
    assert_equal 7, sentinels.size
    assert_equal 'gamma', sentinels[5].node
    assert_equal 3, sentinels[6].route_id
    assert_equal '2030-12-31T13:00:02', sentinels[6].time
  end

  def test_build_routes_with_empty
    routes = @driver.build_routes(routes: [])
    assert_equal 0, routes.size
  end

  def test_build_routes_with_nil
    routes = @driver.build_routes(routes: nil)
    assert_equal 0, routes.size
  end

  def test_build_routes_with_data
    routes = @driver.build_routes(routes: sentinels_routes)
    assert_equal 2, routes.size

    first_route = routes.first
    last_route = routes.last

    assert_equal 'alpha', first_route.start_node
    assert_equal 'gamma', first_route.end_node
    assert_equal '2030-12-31T13:00:01', first_route.start_time
    assert_equal '2030-12-31T13:00:03', first_route.end_time
    refute_equal last_route.start_node, last_route.end_node
  end

  private

  def sentinels_routes_csv
    <<~CONTENT
      "route_id", "node", "index", "time"
      "1", "alpha", "0", "2030-12-31T22:00:01+09:00"
      "1", "beta", "1", "2030-12-31T18:00:02+05:00"
      "1", "gamma", "2", "2030-12-31T16:00:03+03:00"
      "2", "delta", "0", "2030-12-31T22:00:02+09:00"
      "2", "beta", "1", "2030-12-31T18:00:03+05:00"
      "2", "gamma", "2", "2030-12-31T16:00:04+03:00"
      "3", "zeta", "0", "2030-12-31T22:00:02+09:00"
    CONTENT
  end

  def sentinels_routes
    [
      Sentinel.new(route_id: '1', node: 'alpha', index: '0', time: '2030-12-31T22:00:01+09:00'),
      Sentinel.new(route_id: '1', node: 'beta',  index: '1', time: '2030-12-31T18:00:02+05:00'),
      Sentinel.new(route_id: '1', node: 'gamma', index: '2', time: '2030-12-31T16:00:03+03:00'),
      Sentinel.new(route_id: '2', node: 'delta', index: '0', time: '2030-12-31T22:00:02+09:00'),
      Sentinel.new(route_id: '2', node: 'beta',  index: '1', time: '2030-12-31T18:00:03+05:00'),
      Sentinel.new(route_id: '2', node: 'gamma', index: '2', time: '2030-12-31T16:00:04+03:00'),
      Sentinel.new(route_id: '3', node: 'zeta',  index: '0', time: '2030-12-31T22:00:02+09:00')
    ]
  end
end
