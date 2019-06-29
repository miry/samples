# frozen_string_literal: true

require 'minitest/autorun'

require_relative 'calculator.rb'

class CalculatorTest < Minitest::Test

  def test_sum
    subject = Calculator.new

    assert_equal(9, subject.evaluate("4 + 5"))
    assert_equal(10, subject.evaluate("4 + 5 + 1"))
  end

  def test_sub
    subject = Calculator.new

    assert_equal(-1, subject.evaluate("4 - 5"))
    assert_equal(-2, subject.evaluate("4 - 5 - 1"))
  end

  def test_multiplication
    subject = Calculator.new

    assert_equal(20, subject.evaluate("4 * 5"))
    assert_equal(40, subject.evaluate("4 * 5 * 2"))
  end

  def test_div
    subject = Calculator.new

    assert_equal(0.8, subject.evaluate("4 / 5"))
  end

  def test_priority
    subject = Calculator.new

    # assert_equal(18, subject.evaluate("4 + 5 * 6 / 2 - 1"))
    assert_equal(8, subject.evaluate("2 + 3 * 4 / 3 - 6 / 3 * 3 + 8"))
  end
end
