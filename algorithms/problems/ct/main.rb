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


def subs(s, t)
  words = s.split(' ')
  existings_words = t.split(' ')

  result = []
  eindex = 0
  windex = 0
  while eindex < existings_words.size
    while windex < words.size
      word = words[windex]
      if word != existings_words[eindex]
        result << word
      else
        eindex += 1
      end
      windex += 1
    end
  end
  result
end


def fourthBit(num)
  num.to_s(2)[-4].to_i
  num >> 3 & 1
end


def kSub(k, nums)
  result = 0
  i = 0
  cache = {}
  while i < nums.size
    result += recursionKSub(k, nums[i..-1], cache)
    i += 1
  end
  result
end


def recursionKSub(k, nums, cache={})
  return cache[nums] if cache.key?(nums)
  result = 0
  sum = 0
  nums.each do |num|
    sum += num
    if sum % k == 0
      result += 1
    end
  end
  cache[nums] = result
  result
end
