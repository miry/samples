# https://adventofcode.com/2019/day/4
#
# --- Day 4: Secure Container ---
#
# You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.
#
# However, they do remember a few key facts about the password:
#
#     It is a six-digit number.
#     The value is within the range given in your puzzle input.
#     Two adjacent digits are the same (like 22 in 122345).
#     Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
#
# Other than the range rule, the following are true:
#
#     111111 meets these criteria (double 11, never decreases).
#     223450 does not meet these criteria (decreasing pair of digits 50).
#     123789 does not meet these criteria (no double).
#
# How many different passwords within the range given in your puzzle input meet these criteria?

def brute_force(start, last)
  result = 0
  (start..last).each do |i|
    result += 1 if valid?(i)
  end
  result
end

def valid?(number)
  digits = to_digits(number)
  doubles = false
  i = 1
  while i < digits.size
    return false if digits[i - 1] > digits[i]
    doubles = true if digits[i - 1] == digits[i]
    i += 1
  end

  return doubles
end

def to_digits(number : Int)
  result = Array(Int32).new(6)
  div = number
  while div >= 10
    div, mod = div.divmod(10)
    result.insert(0, mod)
  end
  result.insert(0, div)
  result
end
