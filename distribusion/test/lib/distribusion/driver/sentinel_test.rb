# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class DriverSentinelTest < Minitest::Test
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
end
