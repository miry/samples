require "minitest/autorun"
require_relative 'sort'

class TestSort < Minitest::Test
  def test_that_sortt_handle_nil
    assert_nil sort(nil)
  end

  def test_that_sortt_handle_non_array
    assert_nil sort(1)
  end

  def test_that_sortt_handle_ints
    assert_equal [1,2,3,4,5], sort([1,3,5,2,4])
  end
end
