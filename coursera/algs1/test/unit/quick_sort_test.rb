require 'test_helper'
require 'quick_sort'

class QuickSortTest < MiniTest::Unit::TestCase

  def test_init_with_array
    subject = QuickSort.new [3, 2, 1]
    assert_equal 3, subject.items.size
  end

  def test_partition_with_three_items
    subject = QuickSort.new [3, 2, 1]
    subject.partition
    assert_equal [1, 2, 3], subject.items
  end

  def test_partition_case1
    subject = QuickSort.new '62 16 32 18 73 43 69 89 80 44 77 52'
    subject.partition
    assert_equal '44 16 32 18 52 43 62 89 80 69 77 73', subject.to_s
  end

  def test_partition_case2
    subject = QuickSort.new %w(A B B A A B A A A A A A)
    subject.partition
    assert_equal 'A A A A A A A B A A B B', subject.to_s
  end

  def test_partition_case3
    subject = QuickSort.new %w(N F Q D B C J T K Y P I)
    subject.partition
    assert_equal 'K F I D B C J N T Y P Q', subject.to_s
  end

  def test_partition_case4
    subject = QuickSort.new '87 62 96 74 57 61 43 15 89 92 13 77'
    subject.partition
    assert_equal '13 62 77 74 57 61 43 15 87 92 89 96', subject.to_s
  end

  def test_partition_case5
    subject = QuickSort.new '32 82 75 63 78 70 26 36 38 30 20 93'
    subject.partition
    assert_equal '26 20 30 32 78 70 63 36 38 75 82 93', subject.to_s
  end

  def test_three_way_partion_case1
    subject = QuickSort.new %w(R B W W R W B R R W B R)
    subject.partition_three_way
    assert_equal 'B B B R R R R R W W W W', subject.to_s
  end

  def test_three_way_partion_case2
    subject = QuickSort.new '41 95 41 71 46 72 19 91 53 41'
    subject.partition_three_way
    assert_equal '19 41 41 41 72 46 91 53 71 95', subject.to_s
  end

  def test_three_way_partion_case3
    subject = QuickSort.new %w(O T G O V X O B A E)
    subject.partition_three_way
    assert_equal 'E G A B O O O X V T', subject.to_s
  end

  def test_three_way_partion_case4
    subject = QuickSort.new %w(41 84 58 41 41 30 40 61 97 80)
    subject.partition_three_way
    assert_equal '40 30 41 41 41 58 61 97 80 84', subject.to_s
  end

  def test_three_way_partion_case5
    subject = QuickSort.new %w(43 88 43 43 30 61 69 35 45 20)
    subject.partition_three_way
    assert_equal '20 30 35 43 43 43 69 45 61 88', subject.to_s
  end

  def test_three_way_partion_case6
    subject = QuickSort.new %w(47 47 53 36 89 95 22 85 87 47)
    subject.partition_three_way
    assert_equal '36 22 47 47 47 95 85 87 89 53', subject.to_s
  end

  def test_partition_case5
    subject = QuickSort.new '43 49 42 86 70 20 51 26 17 52 11 55'
    subject.partition
    assert_equal '20 11 42 17 26 43 51 70 86 52 49 55', subject.to_s
  end

end
