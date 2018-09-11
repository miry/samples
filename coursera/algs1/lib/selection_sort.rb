class SelectionSort
  def initialize(items)
    @items = items.is_a?(String) ? items.split(' ').map(&:to_i) : items
  end

  def sort!(count_of_exchanges=nil)
    exchanges = 0
    @items.size.times do |i|
      min = i
      j = i + 1
      while(j < @items.size)
        min = j if @items[j] < @items[min]
        j += 1
      end
      exchange(i, min)
      exchanges += 1
      return exchanges if exchanges == count_of_exchanges
    end
    exchanges
  end

  def exchange(i, j)
    @items[i], @items[j] = @items[j], @items[i]
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
  sorter = SelectionSort.new(items)
  sorter.sort!
  puts sorter
end
