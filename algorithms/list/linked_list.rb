class LinkedListNode

  attr_accessor :value, :next

  def initialize(value)
    @value = value
    @next  = nil
  end
end

a = LinkedListNode.new('A')
b = LinkedListNode.new('B')
c = LinkedListNode.new('C')

a.next = b
b.next = c


def delete_node(node)
  next_node = node.next
  raise 'Could not destroy last node!' if next_node.nil?
  node.value = next_node.value
  node.next = next_node.next
end

delete_node(b)
p a
