require "minitest/autorun"
require "./node"

class NodeTest < Minitest::Test
  def node
    @node ||= Node.new
  end

  def test_get_value
    subject = Node.new("foo")
    assert_equal "foo", subject.value
  end

  def test_list_with_two_nodes
    first : Node = Node.new("foo")
    second : Node = Node.new("quux")
    first.next = second
    assert_equal ["foo", "quux"], first.values
  end

  def test_list_append_two_nodes
    first : Node = Node.new("foo")
    second : Node = Node.new("quux")
    third : Node = Node.new("bar")
    first.append(second)
    first.append(third)
    assert_equal ["foo", "quux", "bar"], first.values
  end

  def test_get_size
    first : Node = Node.new("foo")
    second : Node = Node.new("quux")
    third : Node = Node.new("bar")
    first.append(second)
    first.append(third)
    assert_equal 3, first.size
  end

  def test_pop_value
    first : Node = Node.new("foo")
    second : Node = Node.new("quux")
    third : Node = Node.new("bar")
    first.append(second)
    first.append(third)
    actual = first.pop()
    assert_equal "bar", actual.value
  end

  def test_pop_decrement_list_size
    first : Node = Node.new("foo")
    second : Node = Node.new("quux")
    third : Node = Node.new("bar")
    first.append(second)
    first.append(third)
    actual = first.pop()
    assert_equal 2, first.size
    assert_equal third, actual
  end

  def test_pop_for_one_item_list
    first : Node = Node.new("foo")
    actual = first.pop()
    assert_equal first, actual
    assert_equal 1, first.size
  end

  def test_delete_node
    first : Node = Node.new("foo")
    second : Node = Node.new("quux")
    third : Node = Node.new("bar")
    first.append(second)
    first.append(third)
    second.delete()

    assert_equal 2, first.size
    assert_equal ["foo", "bar"], first.values
  end
end
