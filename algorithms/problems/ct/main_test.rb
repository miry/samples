require "minitest/autorun"
require_relative 'main'

class TestSolution < Minitest::Test
  def test_sort_sample_1
    assert_equal [1, 3, 4, 2, 2], sort([3,1,2,2,4])
  end

  def test_sort_sample
    assert_equal [8, 4, 4, 1, 1, 1, 5, 5, 5, 5], sort([8, 5, 5, 5, 5, 1, 1, 1, 4, 4])
  end

end
