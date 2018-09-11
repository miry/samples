require 'test_helper'
require 'selection_sort'

class SelectionSortTest < MiniTest::Unit::TestCase

  def test_intit_with_array
    subject = SelectionSort.new [3, 2, 1]
    assert_equal 3, subject.items.size
  end

  def test_sort_case_1
    subject = SelectionSort.new '24 28 56 77 95 46 39 75 84 18'
    subject.sort!
    assert_equal '18 24 28 39 46 56 75 77 84 95', subject.to_s
  end

  def test_sort_with_one_exchange
    subject = SelectionSort.new '34 79 29 17 46 61 66 70 45 63'
    subject.sort!(1)
    assert_equal '17 79 29 34 46 61 66 70 45 63', subject.to_s
  end

  def test_sort_with_two_exchanges
    subject = SelectionSort.new '34 79 29 17 46 61 66 70 45 63'
    subject.sort!(2)
    assert_equal '17 29 79 34 46 61 66 70 45 63', subject.to_s
  end

  def test_sort_with_three_exchanges
    subject = SelectionSort.new '34 79 29 17 46 61 66 70 45 63'
    subject.sort!(3)
    assert_equal '17 29 34 79 46 61 66 70 45 63', subject.to_s
  end

  def test_sort_with_four_excahnges
    subject = SelectionSort.new '34 79 29 17 46 61 66 70 45 63'
    subject.sort!(4)
    assert_equal '17 29 34 45 46 61 66 70 79 63', subject.to_s
  end

end
