class InsertSort
  def initialize(items)
    @items = items.is_a?(String) ? items.split(' ').map(&:to_i) : items
  end

  def sort!(count_of_exchanges=nil)
    j = 1
    exchanges = 0
    while j < @items.size
      i   = j - 1
      key = @items[j]

      while i >= 0 && key < @items[i]
        @items[i + 1] = @items[i]
        i -= 1
        exchanges += 1

        if exchanges == count_of_exchanges
          @items[i + 1] = key
          return
        end
      end

      if @items[j] != key
        @items[i + 1] = key
      end

      j += 1
    end
  end

  def to_s
    @items.join(' ')
  end

  def items
    @items
  end
end

if __FILE__ == $0
# Tail starts here
  puts "Input items: "
  items = gets.split(' ').map(&:to_i)
  sorter = InsertSort.new(items)
  sorter.sort!
  puts sorter
end
