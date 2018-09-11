require 'test_helper'
require 'weighted_quick_find'

class WQuickFindUFTest < MiniTest::Unit::TestCase

  def subject
    @subject ||= WQuickFindUF.new(10)
  end

  def test_initialize_ids_with_ten_elements
    assert_equal 10, subject.ids.size
  end

  def test_connected_return_false_if_not_connected
    assert !subject.connected?(0, 1)
  end

  def test_connected_after_union_for_same_items
    subject.union(0, 1)
    assert subject.connected?(0, 1)
  end

  def test_return_root_for_one_item_union
    assert_equal 0, subject.root(0)
    assert_equal 1, subject.root(1)
  end

  def test_return_root_for_multi_item_union
    subject.union(0, 1)
    assert_equal subject.root(0), subject.root(1)
  end

  def test_use_right_index_as_root_for_equal_unions
    subject.union(0, 1)
    assert_equal 0, subject.root(0)
    assert_equal 0, subject.root(1)
  end

  def test_return_union_size_for_single_unions
    assert_equal 1, subject.size(0)
  end

  def test_union_collection_wiht_single_element
    subject.union(9, 2)
    assert_equal [0, 1, 9, 3, 4, 5, 6, 7, 8, 9], subject.ids

    subject.union(0, 2)
    assert_equal [9, 1, 9, 3, 4, 5, 6, 7, 8, 9], subject.ids
  end

  def test_update_root_for_single_elements
    subject.union(6, 7)
    assert_equal [0, 1, 2, 3, 4, 5, 6, 6, 8, 9], subject.ids
    subject.union(9, 2)
    assert_equal [0, 1, 9, 3, 4, 5, 6, 6, 8, 9], subject.ids
    subject.union(0, 1)
    assert_equal [0, 0, 9, 3, 4, 5, 6, 6, 8, 9], subject.ids
    subject.union(4, 5)
    assert_equal [0, 0, 9, 3, 4, 4, 6, 6, 8, 9], subject.ids
  end

  def test_from_quiz_1
    values = convert_to_array("6-7 9-2 0-1 4-5 0-2 3-7 5-7 4-1 2-8")
    subject.unions values
    assert_equal [6, 0, 9, 6, 6, 4, 6, 6, 6, 0], subject.ids
  end

  def test_from_quiz_131
    values = convert_to_array("0-8 9-1 0-9 2-3 3-5 5-7 2-0 5-6 5-4")
    subject.unions values
    assert_equal [2, 9, 2, 2, 2, 2, 2, 2, 0, 0], subject.ids
  end

  def test_from_quiz_132
    values = convert_to_array("4-3 0-1 3-2 8-9 5-2 0-9 5-0 3-6 7-5")
    subject.unions values
    assert_equal [4, 0, 4, 4, 4, 4, 4, 4, 0, 8], subject.ids
  end

  def convert_to_array(str)
    str.split(' ').map{|i| i.split('-').map(&:to_i) }
  end
end
