# https://adventofcode.com/2020/day/1
#
# --- Day 1: Report Repair ---
#
# After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.
#
# The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.
#
# To save your vacation, you need to get all fifty stars by December 25th.
#
# Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!
#
# Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.
#
# Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.
#
# For example, suppose your expense report contained the following:
#
# 1721
# 979
# 366
# 299
# 675
# 1456
#
# In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.
#
# Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?
#
# Your puzzle answer was 955584.
def find_two_to_sum(arr : Array(Int64), sum : Int64) : Array(Int64)
  base = Hash(Int64, Int64).new
  arr.each do |entry|
    other = sum - entry
    return [other, entry] if base.has_key?(other)
    base[entry] = other
  end
  return [] of Int64
end

def mul_two_entries_to_sum(arr : Array(Int64), sum : Int64) : Int64
  mul_entries_to_sum(arr, 2, sum)
end


# --- Part Two ---
#
# The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.
# 
# Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.
# 
# In your expense report, what is the product of the three entries that sum to 2020?
# 
# Your puzzle answer was 287503934.

def find_entries_to_sum(arr : Array(Int64), n, sum : Int64) : Array(Int64)
  return find_two_to_sum(arr, sum) if n == 2

  arr.each_with_index do |entry, i|
    other = sum - entry
    entries = find_entries_to_sum(arr[i + 1..], n - 1, other)
    return [entry] + entries if !entries.empty?
  end
  return [] of Int64
end

def mul_entries_to_sum(arr : Array(Int64), n, sum : Int64) : Int64
  entries = find_entries_to_sum(arr, n, sum)
  return Int64.new(0) if entries.empty?
  return entries.reduce { |acc, i| acc * i }
end