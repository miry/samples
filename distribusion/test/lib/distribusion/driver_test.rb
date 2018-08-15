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
    @importer.stub :load, sentinels_routes_csv do
      sentinels = @importer.import_sentinels
      assert_equal 7, sentinels.size
      assert_equal 'gamma', sentinels[5].node
      assert_equal 3, sentinels[6].route_id
      assert_equal '2030-12-31T13:00:02', sentinels[6].time
    end
  end

  def test_importer_sniffer_parse_csv
    @importer.stub :load, sniffers_routes_csv do
      records = @importer.import_sniffers
      assert_equal 0, records.size
    end
  end

  def test_importer_loopholes_parse_csv
    @importer.stub :load, loopholes_routes_csv do
      records = @importer.import_loopholes
      assert_equal 0, records.size
    end
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

  def sniffers_routes_csv
    <<~CONTENT

    CONTENT
  end

  def loopholes_routes_csv
    <<~CONTENT

    CONTENT
  end
end
