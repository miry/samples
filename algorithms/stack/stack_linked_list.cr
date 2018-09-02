require "../list/node"

class StackLinkedList
  @head : Node?
  @size = 0

  def push(item)
    node = Node.new(item)
    if @head.nil?
      @head = node
    else
      node.next = @head
      @head = node
    end
    @size += 1
  end

  def pop : String?
    return nil if @head.nil? || empty?
    node = @head.as(Node)
    @size -= 1
    @head = node.next
    node.next = nil
    node.value
  end

  def empty? : Bool
    @size == 0
  end

  def size
    @size
  end
end