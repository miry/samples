class QuickSort
  attr_accessor :sort_type, :verbose, :items

  def initialize(items, sort_type: :top_down, verbose: false)
    @items = items.is_a?(String) ? items.split(' ').map(&:to_i) : items
    @sort_type = sort_type
    @verbose = verbose
  end

  def partition
    lo = 0
    mid = @items[0]
    i = 0
    j = @items.size
    hi = j - 1

    while i < j
      while(@items[i += 1] < mid)
        break if i > j || i == hi
      end

      while(@items[j -= 1] > mid)
        break if j < i || j == lo
      end

      swap(i, j) if i < j
    end

    swap(j, 0)
  end

  def swap(i, j)
    @items[i], @items[j] = @items[j], @items[i]
  end

  def partition_three_way
    lt = 0
    v = @items.first
    i = 1
    gt = @items.size - 1

    while i < gt
      if @items[i] < v
        swap(lt, i)
        lt += 1
        i += 1
      elsif @items[i] > v
        swap(gt, i)
        gt -= 1
      else
        i += 1
      end

    end
  end

  def to_s
    @items.join(' ')
  end
end
