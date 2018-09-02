require "minitest/autorun"
require "./merge"

class MergeTest < Minitest::Test
  def test_arr_sort_one_element
    actual = Merge.sort([1])
    assert_equal [1], actual
  end

  def test_arr_sort_two_sorted_elements
    actual = Merge.sort([1,2])
    assert_equal [1,2], actual
  end

  def test_arr_sort_two_unsorted_elements
    actual = Merge.sort([2,1])
    assert_equal [1,2], actual
  end

  def test_arr_sorted_four_elements
    actual = Merge.sort([1,2,3,4])
    assert_equal [1,2,3,4], actual
  end

  def test_arr_small_unsorted
    actual = Merge.sort([1,2,4,3])
    assert_equal [1,2,3,4], actual
  end

  def test_arr_unsorted
    actual = Merge.sort([4,3,2,1])
    assert_equal [1,2,3,4], actual
  end

  def test_arr_unsorted_five_elements
    actual = Merge.sort([5,4,3,2,1])
    assert_equal [1,2,3,4,5], actual
  end

  def test_arr_unsorted_six_elements
    actual = Merge.sort([6,5,4,3,2,1])
    assert_equal [1,2,3,4,5,6], actual
  end

  def test_arr_random
    r = Random.new
    subject = Array(Int32).new(67) { |i| r.rand(1000) }
    actual = Merge.sort(subject)
    assert_equal subject.sort, actual
  end
end
