# frozen_string_literal: false

require 'minitest/autorun'

require_relative 'stolen_breakfast.rb'

class StolenBreakfastTest < Minitest::Test
  def test_for_success
    assert_equal 3, stolen_breakfast([1,2,3,4,5,5,4,1,2])
  end
end
