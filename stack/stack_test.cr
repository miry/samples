require "minitest/autorun"
require "./stack"

class StackTest < Minitest::Test
  def test_empty_on_init
    assert_equal true, Stack.new.empty?
  end

  def test_no_items_on_init
    assert_equal 0, Stack.new.size
  end
end