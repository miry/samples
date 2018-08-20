FULL = [1,2,3,4,5,6,7,8,9]

def sudoku(board)
  fill_board(board)
end

def fill_board(board)
  result = clone board
  i = 1
  while !valid?(result) do
    result = clone result
    i += 1
    raise "Looping" if i == 1000
  end
  result
end

def clone(board)
  result = Array.new 9
  9.times do |row|
    result[row] = Array.new 9
    9.times do |col|
      result[row][col] = case board[row][col]
                          when 0, Array
                            possible_cell(board: board, row: row, col: col)
                         else
                           board[row][col]
                         end
    end
  end
  result
end

def fill_row(row, permutation_index=1)
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

def valid?(board)
  board.all? do |row|
    valid_row?(row)
  end || (return false)

  9.times do |col|
    valid_col?(board, col) || (return false)
  end

  3.times do |i|
    3.times do |j|
      valid_block?(board, [i,j]) || (return false)
    end
  end

  true
end

def valid_row?(row)
  s = row.uniq
  s.size == 9 && !s.include?(0)
end

def valid_col?(board, col)
  valid_row? board.map {|row| row[col] }
end

def valid_block?(board, coord)
  valid_row?(get_block(board, coord))
end

def print(board)
  board.each do |row|
    # puts row.map {|i| i.is_a?(Array) ? 0 : i}.join(" ")
    puts row.map {|i| i.is_a?(Array) ? "#{i}" : i}.join(" ")
  end
end

def get_row(board, i)
  board[i].reject {|i| i.is_a? Array }
end

def get_col(board, i)
  result = Array.new 9
  9.times {|r| result[r] = board[r][i] }
  result.reject {|i| i.is_a? Array }
end

def get_block(board, coord)
  first_row = coord[0] * 3
  last_row = first_row + 2

  rows = board[first_row..last_row]

  first_col = coord[1] * 3
  last_col = first_col + 2

  rows.map {|r| r[first_col..last_col].reject {|i| i.is_a? Array } }.flatten
end

def possible_cell(board: board, row: row, col: col)
  result = FULL - get_row(board, row) - get_col(board, col) - get_block(board, [row/3,col/3])
  return result.first if result.size == 1
  result
end
