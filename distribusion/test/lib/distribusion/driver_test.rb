# frozen_string_literal: true

require "test_helper"

class DriverTest < Minitest::Test
  def setup
    @driver = Distribusion::Driver.new(passphrase: "test")
  end

  def test_obj
    assert @driver
  end
end
