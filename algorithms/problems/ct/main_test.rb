require "minitest/autorun"
require_relative 'main'

class TestSolution < Minitest::Test
  def test_sort_sample_1
    assert_equal [1, 3, 4, 2, 2], sort([3,1,2,2,4])
  end

  def test_sort_sample
    assert_equal [8, 4, 4, 1, 1, 1, 5, 5, 5, 5], sort([8, 5, 5, 5, 5, 1, 1, 1, 4, 4])
  end

  def test_sub_sample
    assert_equal %w[I using programming], subs("I am using HackerRank to improve programming", "am HackerRank to improve")
  end

  def test_sub_sample_two
    assert_equal %w[I using am programming], subs("I am using am HackerRank to improve programming", "am HackerRank to improve")
  end

  def test_forbit_sample
    assert_equal 0, fourthBit(32)
    assert_equal 0, fourthBit(23)
  end

  def test_rec_k_sub
    assert_equal 1, kSub(5, [5])
    assert_equal 3, kSub(5, [5, 10])
    assert_equal 3, kSub(5, [5, 10, 11])
    assert_equal 1, kSub(5, [11, 9])
    assert_equal 3, kSub(5, [10, 11, 9])
    assert_equal 6, kSub(5, [5, 10, 11, 9])
    assert_equal 10,kSub(5, [5, 10, 11, 9, 5])
  end

  def test_rec_ks
    assert_equal 1, recursionKSub(5, [5])
    assert_equal 1, recursionKSub(5, [10])
    assert_equal 2, recursionKSub(5, [5, 10])
    assert_equal 2, recursionKSub(5, [5, 10, 11])
  end
end
