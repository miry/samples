require 'test_helper'
require 'merge_sort'

class MergeSortTest < MiniTest::Unit::TestCase

  def test_intit_with_array
    subject = MergeSort.new [3, 2, 1]
    assert_equal 3, subject.items.size
  end

  def test_sort_case_1
    subject = MergeSort.new '24 28 56 77 95 46 39 75 84 18'
    subject.sort!
    assert_equal '18 24 28 39 46 56 75 77 84 95', subject.to_s
  end

  def test_sort_two_items_sorted_array
    subject = MergeSort.new [1, 2]
    subject.sort!
    assert_equal [1, 2], subject.items
  end

  def test_sort_two_items_unsorted_array
    subject = MergeSort.new [2, 1]
    subject.sort!
    assert_equal [1, 2], subject.items
  end

  def test_sort_three_items_unsorted_array
    subject = MergeSort.new [3, 2, 1]
    subject.sort!
    assert_equal [1, 2, 3], subject.items
  end

  def test_sort_four_items_unsorted_array
    subject = MergeSort.new [4, 3, 2, 1]
    subject.sort!
    assert_equal [1, 2, 3, 4], subject.items
  end

  def test_do_two_merge_only
    subject = MergeSort.new [4, 3, 2, 1]
    subject.sort!(2)
    assert_equal [3, 4, 1, 2], subject.items
  end

  def test_do_one_merge_only
    subject = MergeSort.new [4, 3, 2, 1]
    subject.sort!(1)
    assert_equal [3, 4, 2, 1], subject.items
  end

  def test_items_after_seventh_call_merge
    subject = MergeSort.new '90 88 33 82 50 29 22 89 60 70 31 69'
    subject.sort! 7
    assert_equal '29 33 50 82 88 90 22 60 89 70 31 69', subject.to_s
  end

  def test_items_after_first_call_merge
    subject = MergeSort.new '90 88 33 82 50 29 22 89 60 70 31 69'
    subject.sort! 1
    assert_equal '88 90 33 82 50 29 22 89 60 70 31 69', subject.to_s
  end

  def test_items_after_seventh_call_merge_case2
    subject = MergeSort.new '34 56 12 79 16 80 33 69 15 31 72 42'
    subject.sort! 7
    assert_equal '12 16 34 56 79 80 15 33 69 31 72 42', subject.to_s
  end

  def test_items_after_seventh_call_merge_case3
    subject = MergeSort.new '66 63 84 60 37 24 71 97 93 21 72 18'
    subject.sort! 7
    assert_equal '24 37 60 63 66 84 71 93 97 21 72 18', subject.to_s
  end

  def test_items_after_seventh_call_merge_case4
    subject = MergeSort.new '32 72 47 79 77 23 85 86 76 40 50 45'
    subject.sort! 7
    assert_equal '23 32 47 72 77 79 76 85 86 40 50 45', subject.to_s
  end

  def test_items_after_seventh_call_merge_case5
    subject = MergeSort.new '20 10 89 73 55 90 98 26 74 68 15 57'
    subject.sort! 7
    assert_equal '10 20 55 73 89 90 26 74 98 68 15 57', subject.to_s
  end

  def test_sort_bottom_up
    subject = MergeSort.new '24 28 56 77 95 46 39 75 84 18', sort_type: :bottom_up
    assert_equal :bottom_up, subject.sort_type
    subject.sort!
    assert_equal '18 24 28 39 46 56 75 77 84 95', subject.to_s
  end

  def test_sort_strings_case_1
    subject = MergeSort.new %w(PINK NENA FUEL ABBA SOAD LIVE BECK KMAG CAKE DOOM SADE CHER), verbose: true
    subject.sort!
    assert_equal 'ABBA BECK CAKE CHER DOOM FUEL KMAG LIVE NENA PINK SADE SOAD', subject.to_s
  end

  def test_sort_strings_case_1_bottom_up
    subject = MergeSort.new %w(PINK NENA FUEL ABBA SOAD LIVE BECK KMAG CAKE DOOM SADE CHER), verbose: true, sort_type: :bottom_up
    subject.sort!
    assert_equal 'ABBA BECK CAKE CHER DOOM FUEL KMAG LIVE NENA PINK SADE SOAD', subject.to_s
  end

  def test_items_after_seventh_call_merge_case4_bottom_up
    subject = MergeSort.new '68 72 33 73 87 34 15 71 17 52', sort_type: :bottom_up
    subject.sort! 7
    assert_equal '33 68 72 73 15 34 71 87 17 52', subject.to_s
  end

  def test_items_after_seventh_call_merge_case5_bottom_up
    subject = MergeSort.new '20 40 35 92 32 56 96 14 53 23', sort_type: :bottom_up
    subject.sort! 7
    assert_equal '20 35 40 92 14 32 56 96 23 53', subject.to_s
  end

  def test_items_after_seventh_call_merge_case1_bottom_up
    subject = MergeSort.new '96 51 36 45 74 12 28 98 21 83', sort_type: :bottom_up
    subject.sort! 7
    assert_equal '36 45 51 96 12 28 74 98 21 83', subject.to_s
  end

end
