# frozen_string_literal: true

require 'test_helper'

class RouteTest < Minitest::Test
  include Distribusion

  Route.logger = setup_logger

  def test_initialization
    @route = Route.new(source: :sentinels,
                       start_node: 'alpha',
                       end_node: 'delta',
                       start_time: '',
                       end_time: '')
  end

  def test_build_routes_from_sentinels
    routes = Distribusion::Route.from_sentinels routes: sentinels
    first_route = routes.first
    last_route = routes.last

    assert_equal 2, routes.size
    assert_equal 'alpha', first_route.start_node
    assert_equal 'gamma', first_route.end_node
    assert_equal '2030-12-31T13:00:01', first_route.start_time
    assert_equal '2030-12-31T13:00:03', first_route.end_time
    refute_equal last_route.start_node, last_route.end_node
  end

  def test_build_routes_from_loopholse
    routes = Distribusion::Route.from_loopholes loopholes_info
    first_route = routes.first
    last_route = routes.last

    assert_equal 2, routes.size
    assert_equal 'gamma', first_route.start_node
    assert_equal 'lambda', first_route.end_node
    assert_equal '2030-12-31T13:00:04', first_route.start_time
    assert_equal '2030-12-31T13:00:06', first_route.end_time
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

  # rubocop:disable Metrics/MethodLength
  def loopholes_info
    {
      node_pairs: [
        { id: '1', start_node: 'gamma', end_node: 'theta' },
        { id: '2', start_node: 'beta', end_node: 'theta' },
        { id: '3', start_node: 'theta', end_node: 'lambda' }
      ],
      routes: [
        { route_id: '1', node_pair_id: '1',
          start_time: '2030-12-31T13:00:04Z', end_time: '2030-12-31T13:00:05Z' },
        { route_id: '1', node_pair_id: '3',
          start_time: '2030-12-31T13:00:05Z', end_time: '2030-12-31T13:00:06Z' },
        { route_id: '2', node_pair_id: '2',
          start_time: '2030-12-31T13:00:05Z', end_time: '2030-12-31T13:00:06Z' },
        { route_id: '2', node_pair_id: '3',
          start_time: '2030-12-31T13:00:06Z', end_time: '2030-12-31T13:00:07Z' },
        { route_id: '3', node_pair_id: '9',
          start_time: '2030-12-31T13:00:00Z', end_time: '2030-12-31T13:00:00Z' }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength
end
