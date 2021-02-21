# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class DriverSnifferTest < Minitest::Test
  include Distribusion

  def setup
    @driver = Distribusion::Driver::Sniffer.new(passphrase: "test")
  end

  def test_importer_sniffer_parse_empty
    records = @driver.parse({})
    assert_equal %i[node_times routes sequences], records.keys
    assert_equal 0, records[:node_times].size
    assert_equal 0, records[:routes].size
    assert_equal 0, records[:sequences].size
  end

  def test_importer_sniffers_parse_nil
    records = @driver.parse(nil)
    assert_equal %i[node_times routes sequences], records.keys
    assert_equal 0, records[:node_times].size
    assert_equal 0, records[:routes].size
    assert_equal 0, records[:sequences].size
  end

  def test_importer_sniffers_parse_sample
    response = {
      'node_times': sniffers_node_times_csv,
      'routes': sniffers_routes_csv,
      'sequences': sniffers_sequences_csv
    }
    records = @driver.parse(response)
    assert_equal %i[node_times routes sequences], records.keys
    assert_equal 4, records[:node_times].size
    assert_equal 3, records[:routes].size
    assert_equal 6, records[:sequences].size
  end

  def test_build_routes_with_empty
    routes = @driver.build_routes(node_times: [], routes: [], sequences: [])
    assert_equal 0, routes.size
  end

  def test_build_routes_with_nil
    routes = @driver.build_routes(node_times: nil, routes: nil, sequences: nil)
    assert_equal 0, routes.size
  end

  def test_build_routes_with_sample
    routes = @driver.build_routes(**sniffers_info)
    assert_equal 2, routes.size
    first_route = routes.first
    last_route = routes.last
    assert_equal "lambda", first_route.start_node
    assert_equal "omega", first_route.end_node
    assert_equal "2030-12-31T13:00:06", first_route.start_time
    assert_equal "2030-12-31T13:00:09", first_route.end_time
    refute_equal last_route.start_node, last_route.end_node
  end

  private

  def sniffers_node_times_csv
    <<~CONTENT
      "node_time_id", "start_node", "end_node", "duration_in_milliseconds"
      "1", "lambda", "tau", "1000"
      "2", "tau", "psi", "1000"
      "3", "psi", "omega", "1000"
      "4", "lambda", "psi", "1000"
    CONTENT
  end

  def sniffers_routes_csv
    <<~CONTENT
      "route_id", "time", "time_zone"
      "1", "2030-12-31T13:00:06", "UTC±00:00"
      "2", "2030-12-31T13:00:07", "UTC±00:00"
      "3", "2030-12-31T13:00:00", "UTC±00:00"
    CONTENT
  end

  def sniffers_sequences_csv
    <<~CONTENT
      "route_id", "node_time_id"
      "1", "1"
      "1", "2"
      "1", "3"
      "2", "4"
      "2", "3"
      "3", "9"
    CONTENT
  end

  # rubocop:disable Metrics/MethodLength
  def sniffers_info
    {
      node_times: [
        {node_time_id: "1", start_node: "lambda", end_node: "tau", duration_in_milliseconds: "1000"},
        {node_time_id: "2", start_node: "tau", end_node: "psi", duration_in_milliseconds: "1000"},
        {node_time_id: "3", start_node: "psi", end_node: "omega", duration_in_milliseconds: "1000"},
        {node_time_id: "4", start_node: "lambda", end_node: "psi", duration_in_milliseconds: "1000"}
      ],
      routes: [
        {route_id: "1", time: "2030-12-31T13:00:06", time_zone: "UTC\u00B100:00"},
        {route_id: "2", time: "2030-12-31T13:00:07", time_zone: "UTC\u00B100:00"},
        {route_id: "3", time: "2030-12-31T13:00:00", time_zone: "UTC\u00B100:00"}
      ],
      sequences: [
        {route_id: "1", node_time_id: "1"},
        {route_id: "1", node_time_id: "2"},
        {route_id: "1", node_time_id: "3"},
        {route_id: "2", node_time_id: "4"},
        {route_id: "2", node_time_id: "3"},
        {route_id: "3", node_time_id: "9"}
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength
end
