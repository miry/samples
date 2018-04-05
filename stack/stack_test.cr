require "minitest/autorun"
require "./stack"

class StackTest < Minitest::Test
  def stack
    @stack ||= Stack.new
  end

  def test_empty_on_init
    assert_equal true, stack.empty?
  end

  def test_no_items_on_init
    assert_equal 0, stack.size
  end

  def test_push_item
    stack.push("foo")
    assert_equal 1, stack.size
  end

  def test_pop_item
    stack.push("foo")
    assert_equal "foo", stack.pop()
  end

  def test_random_push_pop
    stack.push("1")
    stack.push("2")
    assert_equal "2", stack.pop()
    stack.push("3")
    stack.push("4")
    assert_equal "4", stack.pop()
    assert_equal "3", stack.pop()
    assert_equal "1", stack.pop()
  end

  def test_pop_empty_stack
    assert_equal nil, stack.pop()
  end
end