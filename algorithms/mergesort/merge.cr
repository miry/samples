class Merge
  def self.sort(arr)
    sort_part(arr, 0, arr.size-1)
    arr
  end

  def self.merge(arr, lo, mid, hi)
    aux = arr[lo..hi]
    # p "------------"
    # p [lo, mid, hi]
    # p aux
    # p arr
    i = 0
    j = mid - lo + 1
    n = hi - lo
    lo.upto(hi) do |k|
      # p ".............."
      # p [i,j,k]
      if i > mid - lo
        arr[k] = aux[j]
        j += 1
      elsif j > n
        arr[k] = aux[i]
        i += 1
      elsif aux[i] > aux[j]
        arr[k] = aux[j]
        j += 1
      else
        arr[k] = aux[i]
        i += 1
      end
    end
  end

  def self.sort_part(arr, lo, hi)
    if hi - lo > 1
      mid = lo + (hi - lo) / 2
      sort_part(arr, lo, mid)
      sort_part(arr, mid + 1, hi)
      merge(arr, lo, mid, hi)
    else
      if arr[lo] > arr[hi]
        arr[lo], arr[hi] = arr[hi], arr[lo]
      end
    end
  end
end
