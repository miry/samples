# frozen_string_literal: true

class InvalidGridException < RuntimeError; end
class NotValidException < RuntimeError; end
class NoChangesException < RuntimeError
  attr_reader :board
  def initialize(board, msg = 'No changes')
    @board = board
    super(msg)
  end
end

FULL = [1, 2, 3, 4, 5, 6, 7, 8, 9].freeze

def sudoku_solver(board)
  sudoku(board)
end

def sudoku(board)
  check_grid?(board)
  fill_board(board)
end

def fill_board(board)
  result = board
  i = 1
  until valid?(result)
    result = clone result
    i += 1
    if i == 1000
      raise 'Looping'
    end
  end
  result
rescue NoChangesException => e
  cell = get_min_possibilities(board: e.board)
  raise NotValidException if cell.nil?
  cell[:cell].each do |c|
    e.board[cell[:row]][cell[:col]] = c
    begin
      return fill_board(e.board)
    rescue NoChangesException, NotValidException
    end
  end
  raise
end

def clone(board)
  result = Array.new 9
  found = false
  9.times do |row|
    result[row] = Array.new 9
    9.times do |col|
      result[row][col] = case board[row][col]
                         when 0
                           r = possible_cell(board: board, row: row, col: col, current: FULL)
                           found = true unless r == 0
                           r
                         when Array
                           r = possible_cell(board: board, row: row, col: col, current: board[row][col])
                           if r.is_a?(Array)
                             diff = board[row][col] - r
                             found = true unless diff.empty?
                           else
                             found = true
                           end
                           r
                         else
                           board[row][col]
                         end
    end
  end
  raise NoChangesException.new(result, 'No changes') unless found
  result
end

def fill_row(row, permutation_index = 1)
  result = Array.new(9)
  subject = unused(row.sort).permutation.first(permutation_index).last
  row.each_with_index do |v, i|
    result[i] = if v == 0
                  subject.shift
                else
                  v
      end
  end
  result
end

def unused(numbers)
  FULL - numbers.sort
end

def check_grid?(board)
  raise InvalidGridException if board.size > 9
  board.each do |row|
    raise InvalidGridException if row.size > 9
    row.each do |cell|
      (cell.is_a?(Numeric) && cell >= 0 && cell <=9) || (raise InvalidGridException)
    end
  end
end

def valid?(board)
  board.all? do |row|
    valid_row?(row)
  end || (return false)

  9.times do |col|
    valid_col?(board, col) || (return false)
  end

  3.times do |i|
    3.times do |j|
      valid_block?(board, [i, j]) || (return false)
    end
  end

  true
end

def valid_row?(row)
  s = row.uniq
  s.size == 9 && !s.include?(0)
end

def valid_col?(board, col)
  valid_row? board.map { |row| row[col] }
end

def valid_block?(board, coord)
  valid_row?(get_block(board, coord))
end

def print_board(board)
  board.each_slice(3) do |rows|
    puts '-' * 180
    rows.each do |row|
      row.each_slice(3) do |cols|
        cols.map do |cell|
          print format('%17s', (cell.is_a?(Array) ? cell.to_s : cell))
        end
        print '  |  '
      end
      puts
    end
  end
  puts '-' * 180
end

def get_row(board, i)
  get_row_possible(board, i).reject { |i| i.is_a? Array }
end

def get_row_possible(board, i)
  result = Array.new 9
  9.times do |r|
    result[r] = board[i][r]
  end
  result
end

def get_col(board, i)
  get_col_possible(board, i).reject { |i| i.is_a? Array }
end

def get_col_possible(board, i)
  result = Array.new 9
  9.times do |r|
    result[r] = board[r][i]
  end
  result
end

def get_block(board, coord)
  get_block_possible(board, coord).flatten(1).reject { |i| i.is_a? Array }.flatten
end

def get_block_possible(board, coord)
  first_row = coord[0] * 3
  last_row = first_row + 2

  rows = board[first_row..last_row]

  first_col = coord[1] * 3
  last_col = first_col + 2

  result = rows.map { |r| r[first_col..last_col] }
  result
end

def possible_cell(board:, row:, col:, current: 0)
  existing = current == 0 ? FULL : current
  result = existing - get_row(board, row) - get_col(board, col) - get_block(board, [row / 3, col / 3])
  return result.first if result.size == 1
  result.each do |val|
    return val if is_uniq(val: val, board: board, row: row, col: col)
  end
  result
end

def is_uniq(val:, board:, row:, col:)
  current = board[row][col]
  # return true unless current == 0 || current.is_a?(Array)
  return false if (val < 1) || (val > 9)

  result = get_block_possible(board, [row / 3, col / 3])
  i = row % 3
  j = col % 3
  result[i][j] = -1
  result = result.flatten.uniq
  return true if !result.include?(0) && !result.include?(val)

  result = get_row_possible(board, row)
  result[col] = -1
  result = result.flatten.uniq
  return true if !result.include?(0) && !result.include?(val)

  result = get_col_possible(board, col)
  result[row] = -1
  result = result.flatten.uniq
  return true if !result.include?(0) && !result.include?(val)

  false
end

def get_min_possibilities(board:)
  raise InvalidGridException if board.nil?
  board.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      if cell.is_a?(Array) && cell.size < 3
        return {
          row: i,
          col: j,
          cell: cell
        }
      end
    end
  end
  nil
end
