require "../list/node"

class StackLinkedList
  @head : Node?
  @size = 0

  def push(item)
    node = Node.new(item)
    if @head.nil?
      @head = node
    else
      @head.as(Node).append(node)
    end
    @size += 1
  end

  def pop : String?
    return nil if @head.nil? || empty?
    node = @head.as(Node).pop
    if node.nil?
      @head = nil
      return nil
    end
    @size -= 1
    @head = nil if @size == 0
    node.value
  end

  def empty? : Bool
    @size == 0
  end

  def size
    @size
  end
end