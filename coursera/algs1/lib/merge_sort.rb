class MergeSort
  attr_accessor :sort_type, :verbose

  def initialize(items, sort_type: :top_down, verbose: false)
    @items = items.is_a?(String) ? items.split(' ').map(&:to_i) : items
    @sort_type = sort_type
    @verbose = verbose
  end

  def sort!(required_merges=nil)
    @merges = 0
    @required_merges = required_merges
    if sort_type == :bottom_up
      bottom_up_sort!
    else
      sort_sub(0, @items.size - 1)
    end
  end

  def bottom_up_sort!
    size = 1
    while size < @items.size
      
      lo = 0
      while lo < (@items.size - size)
        merge(lo, lo+size-1, [lo+size+size-1, @items.size-1].min);
        lo += size*2
      end
      size *= 2
    end
  end

  def merge(lo, mid, hi)
    return if @merges == @required_merges
    aux = @items.dup
    i, j = lo, mid + 1

    lo.upto(hi) do |k|
      if i > mid
        @items[k]= aux[j]
        j += 1
      elsif j > hi
        @items[k] = aux[i]
        i += 1
      elsif aux[j] < aux[i]
        @items[k] = aux[j]
        j += 1
      else
        @items[k] = aux[i]
        i += 1
      end
    end
    @merges += 1
    puts "%d: %s" % [@merges, to_s] if verbose
  end

  def sort_sub(lo, hi)
    return if @merges == @required_merges
    return if hi <= lo
    mid = lo + (hi - lo) / 2
    sort_sub(lo, mid)
    return if @merges == @required_merges
    sort_sub(mid+1, hi)
    return if @merges == @required_merges
    merge(lo, mid, hi)
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
  sorter = MergeSort.new(items)
  sorter.sort!
  puts sorter
end
