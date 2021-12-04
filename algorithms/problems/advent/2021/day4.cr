# https://adventofcode.com/2021/day/4
#
# --- Day 4: Giant Squid ---
#
# You're already almost 1.5km (almost a mile) below the surface of the ocean, already so deep that you can't see any sunlight. What you can see, however, is a giant squid that has attached itself to the outside of your submarine.
#
# Maybe it wants to play bingo?
#
# Bingo is played on a set of boards each consisting of a 5x5 grid of numbers. Numbers are chosen at random, and the chosen number is marked on all boards on which it appears. (Numbers may not appear on all boards.) If all numbers in any row or any column of a board are marked, that board wins. (Diagonals don't count.)
#
# The submarine has a bingo subsystem to help passengers (currently, you and the giant squid) pass the time. It automatically generates a random order in which to draw numbers and a random set of boards (your puzzle input). For example:
#
# 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
#
# 22 13 17 11  0
#  8  2 23  4 24
# 21  9 14 16  7
#  6 10  3 18  5
#  1 12 20 15 19
#
#  3 15  0  2 22
#  9 18 13 17  5
# 19  8  7 25 23
# 20 11 10 24  4
# 14 21 16 12  6
#
# 14 21 17 24  4
# 10 16 15  9 19
# 18  8 23 26 20
# 22 11 13  6  5
#  2  0 12  3  7
#
# After the first five numbers are drawn (7, 4, 9, 5, and 11), there are no winners, but the boards are marked as follows (shown here adjacent to each other to save space):
#
# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
#
# After the next six numbers are drawn (17, 23, 2, 0, 14, and 21), there are still no winners:
#
# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
#
# Finally, 24 is drawn:
#
# 22 13 17 11  0         3 15  0  2 22        14 21 17 24  4
#  8  2 23  4 24         9 18 13 17  5        10 16 15  9 19
# 21  9 14 16  7        19  8  7 25 23        18  8 23 26 20
#  6 10  3 18  5        20 11 10 24  4        22 11 13  6  5
#  1 12 20 15 19        14 21 16 12  6         2  0 12  3  7
#
# At this point, the third board wins because it has at least one complete row or column of marked numbers (in this case, the entire top row is marked: 14 21 17 24 4).
#
# The score of the winning board can now be calculated. Start by finding the sum of all unmarked numbers on that board; in this case, the sum is 188. Then, multiply that sum by the number that was just called when the board won, 24, to get the final score, 188 * 24 = 4512.
#
# To guarantee victory against the giant squid, figure out which board will win first. What will your final score be if you choose that board?
#
# Your puzzle answer was 44736.

class Board
  property board : Array(Array(Int32))
  property size : Int32

  def initialize(@board)
    @played = Set(Int32).new
    @size = @board.size
  end

  def play(num : Int32)
    @played.add(num)
  end

  def win? : Bool
    @size.times do |r|
      if @board[r].all? { |n| @played.includes?(n) }
        return true
      end
    end

    @size.times do |c|
      found = true
      @size.times do |r|
        if !@played.includes?(@board[r][c])
          found = false
          break
        end
      end

      return true if found
    end
    return false
  end

  def score(played)
    result = 0
    @board.each do |row|
      unplayed = row.select { |n| !@played.includes?(n) }
      if unplayed.size > 0
        result += unplayed.reduce(0) { |acc, i| acc + i }
      end
    end
    return result * played
  end

  def print
    @board.each do |row|
      r = ""
      row.each do |cell|
        r += cell.to_s
        r += '*' if @played.includes?(cell)
        r += ' '
      end
      puts r
    end
  end

  def self.parse(input : Array(String))
    board = Array(Array(Int32)).new
    input.each do |row|
      numbers = row.strip.split(/ +/).map(&.to_i32)
      board << numbers
    end
    return Board.new(board)
  end
end

def problem4(records : Array(String))
  draw = records[0].split(",").map(&.to_i32)
  board = Array(String).new
  i = 2
  n = records.size

  boards = Array(Board).new
  while i < n
    row = records[i]
    if row == ""
      boards << Board.parse(board)
      board = Array(String).new
    else
      board << row
    end
    i += 1
  end
  boards << Board.parse(board)

  winner = nil
  last_payed = 0
  draw.each do |play_num|
    last_payed = play_num
    boards.each_with_index do |board, i|
      board.play(play_num)
      if board.win?
        winner = board
        break
      end
    end
    break if !winner.nil?
  end

  return winner.nil? ? 0 : winner.score(last_payed)
end

# --- Part Two ---
#
# On the other hand, it might be wise to try a different strategy: let the giant squid win.
#
# You aren't sure how many bingo boards a giant squid could play at once, so rather than waste time counting its arms, the safe thing to do is to figure out which board will win last and choose that one. That way, no matter which boards it picks, it will win for sure.
#
# In the above example, the second board is the last to win, which happens after 13 is eventually called and its middle column is completely marked. If you were to keep playing until this point, the second board would have a sum of unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.
#
# Figure out which board will win last. Once it wins, what would its final score be?
#
# Your puzzle answer was 1827.

def problem4_part_two(records : Array(String))
  draw = records[0].split(",").map(&.to_i32)

  i = 2
  n = records.size

  board = Array(String).new
  boards = Array(Board).new
  while i < n
    row = records[i]
    if row == ""
      boards << Board.parse(board)
      board = Array(String).new
    else
      board << row
    end
    i += 1
  end
  if board.size > 0
    boards << Board.parse(board)
  end

  winner = nil
  last_payed = 0
  draw.each do |play_num|
    last_payed = play_num
    boards.each_with_index do |board, i|
      board.play(play_num)
    end
    boards = boards.select { |b| !b.win? }
    if boards.size == 1
      winner = boards[0]
    end

    if boards.size == 0
      break
    end
  end

  return winner.nil? ? 0 : winner.score(last_payed)
end
