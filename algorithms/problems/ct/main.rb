def sort(arr)
  return nil if arr.nil?

  elements = {}

  arr.each do |i|
    elements[i] ||= 0
    elements[i] += 1
  end

  buckets = []
  elements.each do |digit, s|
    buckets[s] ||= []
    buckets[s].append digit
    buckets[s] = buckets[s].sort
  end

  result = []
  buckets.each_with_index do |items, index|
    next if items.nil?
    items.each do |i|
      index.times do
        result << i
      end
    end
  end
  result.flatten
end
