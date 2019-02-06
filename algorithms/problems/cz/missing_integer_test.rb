require "minitest/autorun"
require_relative 'missing_integer'

class TestMissingInterger < Minitest::Test
  def test_smallest_long
    assert_equal 5, missing_integer([1, 3, 6, 4, 1, 2])
  end

  def test_smallest_short
    assert_equal 4, missing_integer([1, 2, 3])
  end

  def test_positive_number
    assert_equal 1, missing_integer([-1, -2, -3])
  end
end
