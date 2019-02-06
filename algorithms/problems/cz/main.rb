def smallest(n)
  return if n.nil? || n.to_i < 1 || n.to_i > 10**9

  digits = 0
  i = n

  while i / 10 > 0
    digits += 1
    i = i / 10
  end

  digits < 1 ? 0 : 10 ** digits
end

def sqrt_chain(a, b)
  return if a.nil? || b.nil? || a < 2 || b > 1_000_000_000 || a > b

  bottom_up(a, b)
end

def up_to_bottom(a, b)
  memo = {}

  i = a
  max = 0
  while i <= b
    sqrts = count_sqrts(i, memo)
    max = sqrts if sqrts > max
    i += 1
  end
  max
end

def count_sqrts(num, memo={})
  return 0 if num == 1
  return memo[num] if memo.key?(num)
  f = Math.sqrt(num)
  i = f.to_i
  return 0 if f != i
  memo[num] = count_sqrts(i)+1
end

def bottom_up(a, b)
  min = Math.sqrt(a)
  min = min.floor+1 if min != min.to_i
  max = Math.sqrt(b).floor

  return 0 if min > max
  bottom_up(min, max) + 1
end
