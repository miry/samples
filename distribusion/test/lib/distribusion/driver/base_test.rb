# frozen_string_literal: true

require 'test_helper'

class DriverBaseTest < Minitest::Test
  include Distribusion

  def test_hash_to_query
    @driver = Driver::Base.new(passphrase: 'xxxx', source: 'foo')
    actual = @driver.send :to_query, foo: 1, bar: 2

    assert_equal 'foo=1&bar=2', actual
  end
end
