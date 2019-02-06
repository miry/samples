require "minitest/autorun"
require_relative 'main'

class TestSolution < Minitest::Test
  def test_that_smallest_negative
    assert_nil smallest(nil)
  end

  def test_that_smallest_to_max
    assert_nil smallest(10**9+10)
  end

  def test_that_smallest_string
    assert_nil smallest('foo')
  end

  def test_that_smallest_nine_digits
    assert_equal 1000000000, smallest(10**9)
  end

  def test_that_smallest_eight_digits
    assert_equal 100000000, smallest(10**8)
  end

  def test_that_smallest_three_digits
    assert_equal 100, smallest(125)
  end

  def test_that_smallest_two_digits
    assert_equal 10, smallest(10)
  end

  def test_that_smallest_one_digits
    assert_equal 0, smallest(1)
  end

  def test_that_sqrt_chain_nil
    assert_nil sqrt_chain(nil, nil)
  end

  def test_that_sqrt_a_more_b_nil
    assert_nil sqrt_chain(10, 2)
  end

  def test_that_sqrt_a_more_than_two
    assert_nil sqrt_chain(1, 2)
  end

  def test_that_sqrt_b_less_than_million
    assert_nil sqrt_chain(2, 1_000_000_001)
  end

  def test_that_sqrt_sample_one
    assert_equal 2, sqrt_chain(10, 20)
  end

  def test_that_sqrt_sample_two
    assert_equal 3, sqrt_chain(6000, 7000)
  end

  def test_that_sqrt_count_sizteen
    assert_equal 2, count_sqrts(16, {})
  end

  def test_that_sqrt_count_four
    assert_equal 1, count_sqrts(4, {})
  end

  def test_that_sqrt_count_sizteen
    assert_equal 3, count_sqrts(6561, {})
  end

  def test_that_sqrt_count_eightyone
    assert_equal 2, count_sqrts(81, {})
  end

  def test_that_sqrt_count_nine
    assert_equal 1, count_sqrts(9, {})
  end
end
