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
end