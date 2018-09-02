class Stack
  def initialize
    @items = [] of String
  end

  def push(item)
    @items << item
  end

  def pop
    return nil if @items.size == 0
    @items.pop
  end

  def empty? : Bool
    size == 0
  end

  def size
    @items.size
  end
end