# frozen_string_literal: true

require 'minitest/autorun'

require_relative 'sudoku.rb'

class SudokuTest < Minitest::Test
  def test_unused
    assert_equal [1, 2, 3, 4, 5, 7], unused([0, 9, 8, 0, 0, 0, 0, 6, 0])
  end

  def test_get_col
    assert_equal [3, 0, 9, 0, 0, 0, 6, 0, 0], get_col(puzzle, 1)
    board = puzzle
    board[1][1] = [1, 2, 3]
    assert_equal [3, 9, 0, 0, 0, 6, 0, 0], get_col(board, 1)
  end

  def test_get_col_possible
    assert_equal [3, 0, 9, 0, 0, 0, 6, 0, 0], get_col_possible(puzzle, 1)
    board = puzzle
    board[1][1] = [1, 2, 3]
    assert_equal [3, [1, 2, 3], 9, 0, 0, 0, 6, 0, 0], get_col_possible(board, 1)
  end

  def test_get_row
    assert_equal [6, 0, 0, 1, 9, 5, 0, 0, 0], get_row(puzzle, 1)
    board = puzzle
    board[1][8] = [1, 2, 3]
    assert_equal [6, 0, 0, 1, 9, 5, 0, 0], get_row(board, 1)
  end

  def test_get_row_possible
    board = puzzle
    board[1][8] = [1, 2, 3]
    assert_equal [6, 0, 0, 1, 9, 5, 0, 0, [1, 2, 3]], get_row_possible(board, 1)
  end

  def test_get_block
    assert_equal [0, 6, 0, 8, 0, 3, 0, 2, 0], get_block(puzzle, [1, 1])
    assert_equal [0, 0, 0, 0, 0, 0, 0, 6, 0], get_block(puzzle, [0, 2])
    board = puzzle
    board[0][8] = [1, 2, 3]
    assert_equal [0, 0, 0, 0, 0, 0, 6, 0], get_block(board, [0, 2])
  end

  def test_clone
    actual = clone(puzzle)
    assert_equal [5, 3, [1, 2, 4], [2, 6], 7, [2, 4, 6, 8], [1, 4, 8, 9], [1, 2, 4, 9], [2, 4, 8]], actual[0]
    assert_equal [[1, 3, 9], 6, [1, 3, 4, 5, 7, 9], [3, 5, 7], [3, 5], 7, 2, 8, 4], actual[6]
  end

  def test_clone_of_clone
    actual = clone clone(puzzle)
    assert_equal [[1, 3, 9], 6, [1, 3, 5, 9], [3, 5], 3, 7, 2, 8, 4], actual[6]
  end

  def test_possible_cell
    print_board puzzle
    assert_equal [1, 2, 4], possible_cell(board: puzzle, row: 0, col: 2)
    assert_equal 0, puzzle[6][8]
    assert_equal 4, possible_cell(board: puzzle, row: 6, col: 8)
  end

  def test_possible_cell_of_cloned
    cloned = clone(puzzle)
    assert_equal [1, 2, 4], possible_cell(board: cloned, row: 0, col: 2)
    assert_equal 0, puzzle[6][8]
    assert_equal 4, cloned[6][8]
  end

  def test_possible_cell_of_cloned_limited
    cloned = clone(puzzle)
    assert_equal [1, 2, 4], possible_cell(board: cloned, row: 0, col: 2, current: 0)
    assert_equal [1, 2, 4], possible_cell(board: cloned, row: 0, col: 2, current: FULL)
    assert_equal 1, possible_cell(board: cloned, row: 0, col: 2, current: [1])
  end

  def test_is_uniq_single
    board = puzzle_hard
    3.times do |i|
      3.times do |j|
        board[i][j] = [5, 7, 9]
      end
    end
    board[0][0] = 3 # uniq 3 in the cell
    assert_equal true, is_uniq(board: board, val: 3, row: 0, col: 0)
  end

  def test_is_uniq_by_block
    board = puzzle_hard
    3.times do |i|
      3.times do |j|
        board[i][j] = [5, 7, 9]
      end
    end
    board[0][0] = [3, 5, 7, 9] # uniq 3 in the cell
    assert_equal false, is_uniq(board: board, val: 0, row: 0, col: 0)
    assert_equal false, is_uniq(board: board, val: 10, row: 0, col: 0)
    assert_equal false, is_uniq(board: board, val: 5, row: 0, col: 0)
    assert_equal true, is_uniq(board: board, val: 3, row: 0, col: 0)
  end

  def test_check_puzzle_1
    assert_equal(sudoku(puzzle), solution)
  end

  def test_check_puzzle_2
    assert_equal(sudoku(puzzle2), solution2)
  end

  def test_check_puzzle_3
    assert_equal(sudoku(puzzle3), solution3)
  end

  def test_check_puzzle_hard
    skip
    assert_equal(sudoku(puzzle_hard), solution_hard)
  end

  private

  def puzzle
    [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9]
    ]
    end

  def puzzle_clone
    [
      [5, 3, [1, 2, 4], [2], 7, [1, 2, 4], [1, 4], [1, 2, 4], [2, 4]],
      [6, [2, 4, 7], [2, 4, 7], 1, 9, 5, [4, 7], [2, 4], [2, 4, 7]],
      [[1, 2], 9, 8, [2, 7], [4], [1, 2, 4, 7], [1, 4, 7], 6, [2, 4, 7]],
      [8, [1, 4, 5, 7], [1, 4, 5, 7, 9], [5, 7, 9], 6, [1, 4, 7], [1, 4, 5, 7, 9], [1, 4, 5, 9], 3],
      [4, [5, 7], [5, 7, 9], 8, [5], 3, [5, 7, 9], [5, 9], 1],
      [7, [1, 4, 5], [1, 4, 5, 9], [5, 9], 2, [1, 4], [1, 4, 5, 9], [1, 4, 5, 9], 6],
      [[1, 3], 6, [1, 3, 4], [3], [3, 4], [1, 4], 2, 8, [4]],
      [[3], [], [3, 6], 4, 1, 9, [3, 6], [3], 5],
      [[1, 3], [1, 4], [1, 3, 4, 6], [3, 6], 8, [1, 4, 6], [1, 3, 4, 6], 7, 9]
    ]
  end

  def solution
    [
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9]
    ]
   end

  def puzzle2
    [
      [5, 6, 0, 8, 4, 7, 0, 0, 0],
      [3, 0, 9, 0, 0, 0, 6, 0, 0],
      [0, 0, 8, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 8, 0, 0, 4, 0],
      [7, 9, 0, 6, 0, 2, 0, 1, 8],
      [0, 5, 0, 0, 3, 0, 0, 9, 0],
      [0, 0, 0, 0, 0, 0, 2, 0, 0],
      [0, 0, 6, 0, 0, 0, 8, 0, 7],
      [0, 0, 0, 3, 1, 6, 0, 5, 9]
    ]
     end

  def solution2
    [
      [5, 6, 1, 8, 4, 7, 9, 2, 3],
      [3, 7, 9, 5, 2, 1, 6, 8, 4],
      [4, 2, 8, 9, 6, 3, 1, 7, 5],
      [6, 1, 3, 7, 8, 9, 5, 4, 2],
      [7, 9, 4, 6, 5, 2, 3, 1, 8],
      [8, 5, 2, 1, 3, 4, 7, 9, 6],
      [9, 3, 5, 4, 7, 8, 2, 6, 1],
      [1, 4, 6, 2, 9, 5, 8, 3, 7],
      [2, 8, 7, 3, 1, 6, 4, 5, 9]
    ]
     end

  def puzzle3
    [
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9],
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0]
    ]
    end

  def solution3
    [
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7]
    ]
  end

  def puzzle_hard
    [
      [0, 0, 6, 1, 0, 0, 0, 0, 8],
      [0, 8, 0, 0, 9, 0, 0, 3, 0],
      [2, 0, 0, 0, 0, 5, 4, 0, 0],
      [4, 0, 0, 0, 0, 1, 8, 0, 0],
      [0, 3, 0, 0, 7, 0, 0, 4, 0],
      [0, 0, 7, 9, 0, 0, 0, 0, 3],
      [0, 0, 8, 4, 0, 0, 0, 0, 6],
      [0, 2, 0, 0, 5, 0, 0, 8, 0],
      [1, 0, 0, 0, 0, 2, 5, 0, 0]
    ]
    end

  def solution_hard
    [
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7]
    ]
  end
end
