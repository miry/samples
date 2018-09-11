require 'test_helper'
require 'shell_sort'

class ShellSortTest < MiniTest::Unit::TestCase

  def test_intit_with_array
    subject = ShellSort.new [3, 2, 1], 4
    assert_equal 3, subject.items.size
  end

  def test_sort_case_1
    subject = ShellSort.new '88 69 20 26 66 70 58 21 11 41', 1
    subject.sort!
    assert_equal '11 20 21 26 41 58 66 69 70 88', subject.to_s
  end

  def test_sort_with_step_2_and_one_exchange
    subject = ShellSort.new '88 69 20 26 66 70 58 21 11 41', 2
    subject.sort!(1)
    assert_equal '20 69 88 26 66 70 58 21 11 41', subject.to_s
  end

  def test_sort_with_step_4_and_sort
    subject = ShellSort.new '76 10 88 29 68 89 50 16 35 20 ', 4
    subject.sort!
    assert_equal '35 10 50 16 68 20 88 29 76 89', subject.to_s
  end

  def test_sort_with_step_4_and_one_exchange
    subject = ShellSort.new '76 10 88 29 68 89 50 16 35 20 ', 4
    subject.sort!(1)
    assert_equal '68 10 88 29 76 89 50 16 35 20', subject.to_s
  end

  def test_sort_with_step_4_and_six_exchange
    subject = ShellSort.new '76 10 88 29 68 89 50 16 35 20 ', 4
    subject.sort!(6)
    assert_equal '35 10 50 16 68 20 88 29 76 89', subject.to_s
  end

  def test_sort_with_step_4_and_two_exchange
    subject = ShellSort.new '76 10 88 29 68 89 50 16 35 20', 4
    subject.sort!(2)
    assert_equal '68 10 50 29 76 89 88 16 35 20', subject.to_s
  end

  def test_sort_with_step_4_and_three_exchange
    subject = ShellSort.new '76 10 88 29 68 89 50 16 35 20', 4
    subject.sort!(3)
    assert_equal '68 10 50 16 76 89 88 29 35 20', subject.to_s
  end

  def test_sort_with_knuth_sorting_and_one_exchange
    result = ShellSort.sort_knuth '88 69 20 26 66 70 58 21 11 41', 1
    assert_equal '66 69 20 26 88 70 58 21 11 41', result
  end

  def test_sort_with_knuth_sorting_and_two_exchange
    result = ShellSort.sort_knuth '88 69 20 26 66 70 58 21 11 41', 2
    assert_equal '66 69 20 21 88 70 58 26 11 41', result
  end

  def test_sort_with_knuth_sorting_and_three_exchange
    result = ShellSort.sort_knuth '88 69 20 26 66 70 58 21 11 41', 3
    assert_equal '66 69 20 21 11 70 58 26 88 41', result
  end

  def test_sort_with_knuth_sorting_and_four_exchange
    result = ShellSort.sort_knuth '88 69 20 26 66 70 58 21 11 41', 4
    assert_equal '11 69 20 21 66 70 58 26 88 41', result
  end

  def test_sort_with_knuth_sorting_and_six_exchange
    result = ShellSort.sort_knuth '88 69 20 26 66 70 58 21 11 41', 6
    assert_equal '11 41 20 21 66 69 58 26 88 70', result
  end

  def test_sort_with_knuth_sorting_and_six_exchange_case_2
    result = ShellSort.sort_knuth '88 90 25 10 13 38 57 64 51 35', 6
    assert_equal '13 25 35 10 51 38 57 64 88 90', result
  end

  def test_sort_with_4_sorting_one_exchange_case_2
    subject = ShellSort.new '88 90 25 10 13 38 57 64 51 35', 4
    subject.sort!(1)
    assert_equal '13 90 25 10 88 38 57 64 51 35', subject.to_s
  end

  def test_sort_with_4_sorting_case_3
    subject = ShellSort.new '41 93 58 80 89 10 35 62 21 82', 4
    subject.sort!
    assert_equal '21 10 35 62 41 82 58 80 89 93', subject.to_s
  end

end
