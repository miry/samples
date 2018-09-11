class ShellSort

  attr_accessor :items, :step

  def initialize(items, step)
    @items = items.is_a?(String) ? items.split(' ').map(&:to_i) : items
    @step = step || 1
  end

  def sort!(count_of_exchanges=nil)
    j = step
    exchanges = 0
    while j < @items.size
      i   = j - step
      key = @items[j]

      while i >= 0 && key < @items[i]
        @items[i + step] = @items[i]
        i -= step
        exchanges += 1

        #puts "%d: %s" % [exchanges, to_s]
        if exchanges == count_of_exchanges
          @items[i + step] = key
          return exchanges
        end
      end

      if @items[j] != key
        @items[i + step] = key
      end

      j += 1
    end
    exchanges
  end

  def self.sort_knuth(items, count_exhanges=nil)
    _items = items.is_a?(String) ? items.split(' ').map(&:to_i) : items
    steps = [1]
    while steps.first < _items.size
      steps.insert(0, steps.first * 3 + 1)
    end
    steps.shift

    _remain_exchanges = count_exhanges
    sorter = self.new _items, 1
    steps.each do |step|
      sorter.step = step
      exchanges = sorter.sort!(_remain_exchanges)
      _remain_exchanges -= exchanges if _remain_exchanges
      break if _remain_exchanges == 0
    end
    sorter.to_s
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
  sorter = ShellSort.new(items)
  sorter.sort!
  puts sorter
end
