require 'test_helper'
require 'quick_find'

class QuickFindUFTest < MiniTest::Unit::TestCase

  def test_initialize_ids_with_ten_elements
    subject = QuickFindUF.new(10)
    assert_equal 10, subject.ids.size
  end

  def test_sample_from_quize
    subject = QuickFindUF.new(10)
    subject.unions([[9, 2], [0, 6], [2, 8], [9, 7], [0, 2], [3, 1]])
    assert_equal [7, 1, 7, 1, 4, 5, 7, 7, 7, 7], subject.ids
  end

  def test_sample_from_quize_1
    subject = QuickFindUF.new(10)
    values = convert_to_array('9-3 8-7 0-8 2-0 6-5 2-4')
    subject.unions(values)
    assert_equal [4, 1, 4, 3, 4, 5, 5, 4, 4, 3], subject.ids
  end

  def test_sample_from_quize_131
    subject = QuickFindUF.new(10)
    values = convert_to_array('9-8 3-6 7-0 6-9 1-9 7-3')
    subject.unions(values)
    assert_equal '8 8 2 8 4 5 8 8 8 8', subject.to_s
  end

  def convert_to_array(str)
    str.split(' ').map{|i| i.split('-').map(&:to_i) }
  end
end

