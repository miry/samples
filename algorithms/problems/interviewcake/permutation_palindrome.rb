# frozen_string_literal: false

=begin
 Write an efficient function that checks whether any permutation ↴ of an input string is a palindrome. ↴

You can assume the input string only contains lowercase letters.

Examples:

    "civic" should return True
    "ivicc" should return True
    "civil" should return False
    "livci" should return False
=end

def permutation_palindrome(input)

  return false if input.nil? || input == ''

  result = {}
  input.chars.each do |c|
    result[c] ||= 0
    result[c] += 1
  end

  odd_once_found = false
  result.each do |k, v|
    if (v % 2) == 1
      return false if odd_once_found 
      odd_once_found = true
    end
  end

  true
end

