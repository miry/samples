# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class DriverTest < Minitest::Test
  def setup
    @importer = Distribusion::Driver.new(passphrase: 'test', logger: setup_logger)
  end

  def test_importer_has_method_import
    assert_includes @importer.methods, :import_sentinels
    assert_includes @importer.methods, :import_sniffers
    assert_includes @importer.methods, :import_loopholes
  end

  def test_importer_sentinels_parse_csv
    @importer.stub(:load, routes: sentinels_routes_csv) do
      sentinels = @importer.import_sentinels
      assert_equal 7, sentinels.size
      assert_equal 'gamma', sentinels[5].node
      assert_equal 3, sentinels[6].route_id
      assert_equal '2030-12-31T13:00:02', sentinels[6].time
    end
  end

  def test_importer_sniffer_parse_csv
    response = {
      'node_times': sniffers_node_times_csv,
      'routes': sniffers_routes_csv,
      'sequences': sniffers_sequences_csv
    }
    @importer.stub :load, response do
      records = @importer.import_sniffers
      assert_equal %i[node_times routes sequences], records.keys
      assert_equal 3, records.size
    end
  end

  def test_importer_loopholes_parse_csv
    response = {
      'node_pairs': loopholes_node_pairs_json,
      'routes': loopholes_routes_json
    }
    @importer.stub :load, response do
      records = @importer.import_loopholes
      assert_equal %i[node_pairs routes], records.keys
    end
  end
end
