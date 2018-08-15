# frozen_string_literal: true

require 'test_helper'

class RouteTest < Minitest::Test
  include Distribusion

  def setup
    @route = Route.new(source: :sentinels,
                       start_node: 'alpha',
                       end_node: 'delta',
                       start_time: '',
                       end_time: '')
  end

  def test_build_routes_from_sentinels
    routes = Distribusion::Route.from_sentinels sentinels
    first_route = routes.first
    last_route = routes.last

    assert_equal 2, routes.size
    assert_equal 'alpha', first_route.start_node
    assert_equal 'gamma', first_route.end_node
    assert_equal '2030-12-31T13:00:01', first_route.start_time
    assert_equal '2030-12-31T13:00:03', first_route.end_time
    refute_equal last_route.start_node, last_route.end_node
  end

  private

  def sentinels
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
