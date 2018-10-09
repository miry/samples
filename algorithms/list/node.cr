class Node
  property value : String
  property next : self | Nil

  def initialize(@value : String?)
  end

  def append(node : self)
    last : self = self
    browse do |item|
      last = item
    end
    last.next = node
  end

  def values
    result = [] of String?
    browse do |item|
      result << item.value
    end
    result
  end

  def pop : self
    prev : self = self
    result : self = self
    browse do |item|
      prev, result = result, item
    end
    prev.next = nil
    result
  end

  def size : Int32
    result = 0
    browse do
      result += 1
    end
    result
  end

  def browse(&block)
    last : self = self
    yield(last)
    while last.next
      last = last.next.as(Node)
      yield(last)
    end
  end

  def delete : self
    return self if self.next.nil?
    next_node : self = self.next.as(Node)
    @value = next_node.value
    @next = next_node.next
    return self
  end
end
