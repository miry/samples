# frozen_string_literal: false

require 'minitest/autorun'

require_relative 'permutation_palindrome.rb'

class PermutationPalindromeTest < Minitest::Test
  def test_with_nil
    assert !permutation_palindrome(nil)
  end

  def test_with_empty
    assert !permutation_palindrome("")
  end

  def test_palindrome_sample
    assert permutation_palindrome("civic")
    assert permutation_palindrome("ivicc")
    assert !permutation_palindrome("civil")
    assert !permutation_palindrome("livci")
  end
end
