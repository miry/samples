# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class DriverLoopholeTest < Minitest::Test
  include Distribusion

  def setup
    @driver = Distribusion::Driver::Loophole.new(passphrase: "test")
  end

  def test_importer_loophole_parse_empty
    records = @driver.parse({})
    assert_equal %i[node_pairs routes], records.keys
    assert_equal 0, records[:node_pairs].size
    assert_equal 0, records[:routes].size
  end

  def test_importer_loopholes_parse_nil
    records = @driver.parse(nil)
    assert_equal %i[node_pairs routes], records.keys
    assert_equal 0, records[:node_pairs].size
    assert_equal 0, records[:routes].size
  end

  def test_importer_loopholes_parse_sample
    response = {
      'node_pairs': loopholes_node_pairs_json,
      'routes': loopholes_routes_json
    }
    records = @driver.parse(response)
    assert_equal %i[node_pairs routes], records.keys
    assert_equal 3, records[:node_pairs].size
    assert_equal 5, records[:routes].size
  end

  def test_build_routes_with_empty
    routes = @driver.build_routes(node_pairs: [], routes: [])
    assert_equal 0, routes.size
  end

  def test_build_routes_with_nils
    routes = @driver.build_routes(node_pairs: [], routes: [])
    assert_equal 0, routes.size
  end

  def test_build_routes_with_sample
    routes = @driver.build_routes(**loopholes_info)
    first_route = routes.first
    last_route = routes.last

    assert_equal 2, routes.size
    assert_equal "gamma", first_route.start_node
    assert_equal "lambda", first_route.end_node
    assert_equal "2030-12-31T13:00:04", first_route.start_time
    assert_equal "2030-12-31T13:00:06", first_route.end_time
    refute_equal last_route.start_node, last_route.end_node
  end

  private

  def loopholes_node_pairs_json
    <<~CONTENT
      {
        "node_pairs": [
          {
            "id": "1",
            "start_node": "gamma",
            "end_node": "theta"
          },
          {
            "id": "2",
            "start_node": "beta",
            "end_node": "theta"
          },
          {
            "id": "3",
            "start_node": "theta",
            "end_node": "lambda"
          }
        ]
      }
    CONTENT
  end

  def loopholes_routes_json
    <<~CONTENT
      {
        "routes": [
          {
            "route_id": "1",
            "node_pair_id": "1",
            "start_time": "2030-12-31T13:00:04Z",
            "end_time": "2030-12-31T13:00:05Z"
          },
          {
            "route_id": "1",
            "node_pair_id": "3",
            "start_time": "2030-12-31T13:00:05Z",
            "end_time": "2030-12-31T13:00:06Z"
          },
          {
            "route_id": "2",
            "node_pair_id": "2",
            "start_time": "2030-12-31T13:00:05Z",
            "end_time": "2030-12-31T13:00:06Z"
          },
          {
            "route_id": "2",
            "node_pair_id": "3",
            "start_time": "2030-12-31T13:00:06Z",
            "end_time": "2030-12-31T13:00:07Z"
          },
          {
            "route_id": "3",
            "node_pair_id": "9",
            "start_time": "2030-12-31T13:00:00Z",
            "end_time": "2030-12-31T13:00:00Z"
          }
        ]
      }
    CONTENT
  end

  # rubocop:disable Metrics/MethodLength
  def loopholes_info
    {
      node_pairs: [
        {id: "1", start_node: "gamma", end_node: "theta"},
        {id: "2", start_node: "beta", end_node: "theta"},
        {id: "3", start_node: "theta", end_node: "lambda"}
      ],
      routes: [
        {route_id: "1", node_pair_id: "1",
         start_time: "2030-12-31T13:00:04Z", end_time: "2030-12-31T13:00:05Z"},
        {route_id: "1", node_pair_id: "3",
         start_time: "2030-12-31T13:00:05Z", end_time: "2030-12-31T13:00:06Z"},
        {route_id: "2", node_pair_id: "2",
         start_time: "2030-12-31T13:00:05Z", end_time: "2030-12-31T13:00:06Z"},
        {route_id: "2", node_pair_id: "3",
         start_time: "2030-12-31T13:00:06Z", end_time: "2030-12-31T13:00:07Z"},
        {route_id: "3", node_pair_id: "9",
         start_time: "2030-12-31T13:00:00Z", end_time: "2030-12-31T13:00:00Z"}
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength
end
