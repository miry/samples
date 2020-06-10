# frozen_string_literal: true

require "minitest/autorun"

require_relative 'board_recovery.rb'

class BoardRecoveryTest < Minitest::Test
  def test_imposible
    actual = board_recovery(0,0,[1])
    assert_equal "IMPOSSIBLE", actual
  end

  def test_simple
    actual = board_recovery(1,1,[2])
    assert_equal "1,1", actual
  end

  def test_case1
    actual = board_recovery(3,2,[2,1,1,0,1])
    assert_equal "11100,10001", actual
  end

  def test_case2
    actual = board_recovery(2,3,[0,0,1,1,2])
    assert_equal "IMPOSSIBLE", actual
  end

  def test_case3
    actual = board_recovery(2,2,[2,0,2,0])
    assert_equal "1010,1010", actual
  end

  def test_case4
    actual = board_recovery(2,3,[2,2,1,1])
    assert_equal "IMPOSSIBLE", actual
  end

end
