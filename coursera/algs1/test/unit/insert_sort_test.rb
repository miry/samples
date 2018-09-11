require 'test_helper'
require 'insert_sort'

class InsertSortTest < MiniTest::Unit::TestCase

  def test_intit_with_array
    subject = InsertSort.new [3, 2, 1]
    assert_equal 3, subject.items.size
  end

  def test_sort_case_1
    subject = InsertSort.new '24 28 56 77 95 46 39 75 84 18'.split(' ').map(&:to_i)
    subject.sort!
    assert_equal '18 24 28 39 46 56 75 77 84 95', subject.to_s
  end

  def test_sort_6_exchanges_case1
    subject = InsertSort.new '30 31 34 73 90 50 70 40 46 20'
    subject.sort!(6)
    assert_equal '30 31 34 50 70 40 73 90 46 20', subject.to_s
  end

  def test_sort_6_exchanges_case2
    subject = InsertSort.new '16 32 52 66 87 54 13 96 90 67'
    subject.sort!(6)
    assert_equal '16 32 13 52 54 66 87 96 90 67', subject.to_s
  end

  def test_sort_6_exchanges_case3
    subject = InsertSort.new '24 28 56 77 95 46 39 75 84 18'
    subject.sort!(6)
    assert_equal '24 28 46 39 56 77 95 75 84 18', subject.to_s
  end

  def test_sort_6_exchanges_case4
    subject = InsertSort.new '21 40 51 93 95 47 60 84 85 72'
    subject.sort!(6)
    assert_equal '21 40 47 51 60 93 84 95 85 72', subject.to_s
  end

  def test_sort_1_exchange
    subject = InsertSort.new '30 31 34 73 90 50 70 40 46 20'
    subject.sort!(1)
    assert_equal '30 31 34 73 50 90 70 40 46 20', subject.to_s
  end

  def test_sort_2_exchange
    subject = InsertSort.new '30 31 34 73 90 50 70 40 46 20'
    subject.sort!(2)
    assert_equal '30 31 34 50 73 90 70 40 46 20', subject.to_s
  end

  def test_sort_3_exchange
    subject = InsertSort.new '30 31 34 73 90 50 70 40 46 20'
    subject.sort!(3)
    assert_equal '30 31 34 50 73 70 90 40 46 20', subject.to_s
  end

  def test_sort_4_exchange
    subject = InsertSort.new '30 31 34 73 90 50 70 40 46 20'
    subject.sort!(4)
    assert_equal '30 31 34 50 70 73 90 40 46 20', subject.to_s
  end

  def test_sort_5_exchange
    subject = InsertSort.new '30 31 34 73 90 50 70 40 46 20'
    subject.sort!(5)
    assert_equal '30 31 34 50 70 73 40 90 46 20', subject.to_s
  end
end
