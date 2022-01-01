# https://adventofcode.com/2021/day/23
#
# --- Day 23: Amphipod ---
#
# A group of amphipods notice your fancy submarine and flag you down. "With such an impressive shell," one amphipod says, "surely you can help us with a question that has stumped our best scientists."
#
# They go on to explain that a group of timid, stubborn amphipods live in a nearby burrow. Four types of amphipods live there: Amber (A), Bronze (B), Copper (C), and Desert (D). They live in a burrow that consists of a hallway and four side rooms. The side rooms are initially full of amphipods, and the hallway is initially empty.
#
# They give you a diagram of the situation (your puzzle input), including locations of each amphipod (A, B, C, or D, each of which is occupying an otherwise open space), walls (#), and open space (.).
#
# For example:
#
# #############
# #...........#
# ###B#C#B#D###
#   #A#D#C#A#
#   #########
#
# The amphipods would like a method to organize every amphipod into side rooms so that each side room contains one type of amphipod and the types are sorted A-D going left to right, like this:
#
# #############
# #...........#
# ###A#B#C#D###
#   #A#B#C#D#
#   #########
#
# Amphipods can move up, down, left, or right so long as they are moving into an unoccupied open space. Each type of amphipod requires a different amount of energy to move one step: Amber amphipods require 1 energy per step, Bronze amphipods require 10 energy, Copper amphipods require 100, and Desert ones require 1000. The amphipods would like you to find a way to organize the amphipods that requires the least total energy.
#
# However, because they are timid and stubborn, the amphipods have some extra rules:
#
#     Amphipods will never stop on the space immediately outside any room. They can move into that space so long as they immediately continue moving. (Specifically, this refers to the four open spaces in the hallway that are directly above an amphipod starting position.)
#     Amphipods will never move from the hallway into a room unless that room is their destination room and that room contains no amphipods which do not also have that room as their own destination. If an amphipod's starting room is not its destination room, it can stay in that room until it leaves the room. (For example, an Amber amphipod will not move from the hallway into the right three rooms, and will only move into the leftmost room if that room is empty or if it only contains other Amber amphipods.)
#     Once an amphipod stops moving in the hallway, it will stay in that spot until it can move into a room. (That is, once any amphipod starts moving, any other amphipods currently in the hallway are locked in place and will not move again until they can move fully into a room.)
#
# In the above example, the amphipods can be organized using a minimum of 12521 energy. One way to do this is shown below.
#
# Starting configuration:
#
# #############
# #...........#
# ###B#C#B#D###
#   #A#D#C#A#
#   #########
#
# One Bronze amphipod moves into the hallway, taking 4 steps and using 40 energy:
#
# #############
# #...B.......#
# ###B#C#.#D###
#   #A#D#C#A#
#   #########
#
# The only Copper amphipod not in its side room moves there, taking 4 steps and using 400 energy:
#
# #############
# #...B.......#
# ###B#.#C#D###
#   #A#D#C#A#
#   #########
#
# A Desert amphipod moves out of the way, taking 3 steps and using 3000 energy, and then the Bronze amphipod takes its place, taking 3 steps and using 30 energy:
#
# #############
# #.....D.....#
# ###B#.#C#D###
#   #A#B#C#A#
#   #########
#
# The leftmost Bronze amphipod moves to its room using 40 energy:
#
# #############
# #.....D.....#
# ###.#B#C#D###
#   #A#B#C#A#
#   #########
#
# Both amphipods in the rightmost room move into the hallway, using 2003 energy in total:
#
# #############
# #.....D.D.A.#
# ###.#B#C#.###
#   #A#B#C#.#
#   #########
#
# Both Desert amphipods move into the rightmost room using 7000 energy:
#
# #############
# #.........A.#
# ###.#B#C#D###
#   #A#B#C#D#
#   #########
#
# Finally, the last Amber amphipod moves into its room, using 8 energy:
#
# #############
# #...........#
# ###A#B#C#D###
#   #A#B#C#D#
#   #########
#
# What is the least energy required to organize the amphipods?
#
# Your puzzle answer was 13066.
# --- Part Two ---
#
# As you prepare to give the amphipods your solution, you notice that the diagram they handed you was actually folded up. As you unfold it, you discover an extra part of the diagram.
#
# Between the first and second lines of text that contain amphipod starting positions, insert the following lines:
#
#   #D#C#B#A#
#   #D#B#A#C#
#
# So, the above example now becomes:
#
# #############
# #...........#
# ###B#C#B#D###
#   #D#C#B#A#
#   #D#B#A#C#
#   #A#D#C#A#
#   #########
#
# The amphipods still want to be organized into rooms similar to before:
#
# #############
# #...........#
# ###A#B#C#D###
#   #A#B#C#D#
#   #A#B#C#D#
#   #A#B#C#D#
#   #########
#
# In this updated example, the least energy required to organize these amphipods is 44169:
#
# #############
# #...........#
# ###B#C#B#D###
#   #D#C#B#A#
#   #D#B#A#C#
#   #A#D#C#A#
#   #########
#
# #############
# #..........D#
# ###B#C#B#.###
#   #D#C#B#A#
#   #D#B#A#C#
#   #A#D#C#A#
#   #########
#
# #############
# #A.........D#
# ###B#C#B#.###
#   #D#C#B#.#
#   #D#B#A#C#
#   #A#D#C#A#
#   #########
#
# #############
# #A........BD#
# ###B#C#.#.###
#   #D#C#B#.#
#   #D#B#A#C#
#   #A#D#C#A#
#   #########
#
# #############
# #A......B.BD#
# ###B#C#.#.###
#   #D#C#.#.#
#   #D#B#A#C#
#   #A#D#C#A#
#   #########
#
# #############
# #AA.....B.BD#
# ###B#C#.#.###
#   #D#C#.#.#
#   #D#B#.#C#
#   #A#D#C#A#
#   #########
#
# #############
# #AA.....B.BD#
# ###B#.#.#.###
#   #D#C#.#.#
#   #D#B#C#C#
#   #A#D#C#A#
#   #########
#
# #############
# #AA.....B.BD#
# ###B#.#.#.###
#   #D#.#C#.#
#   #D#B#C#C#
#   #A#D#C#A#
#   #########
#
# #############
# #AA...B.B.BD#
# ###B#.#.#.###
#   #D#.#C#.#
#   #D#.#C#C#
#   #A#D#C#A#
#   #########
#
# #############
# #AA.D.B.B.BD#
# ###B#.#.#.###
#   #D#.#C#.#
#   #D#.#C#C#
#   #A#.#C#A#
#   #########
#
# #############
# #AA.D...B.BD#
# ###B#.#.#.###
#   #D#.#C#.#
#   #D#.#C#C#
#   #A#B#C#A#
#   #########
#
# #############
# #AA.D.....BD#
# ###B#.#.#.###
#   #D#.#C#.#
#   #D#B#C#C#
#   #A#B#C#A#
#   #########
#
# #############
# #AA.D......D#
# ###B#.#.#.###
#   #D#B#C#.#
#   #D#B#C#C#
#   #A#B#C#A#
#   #########
#
# #############
# #AA.D......D#
# ###B#.#C#.###
#   #D#B#C#.#
#   #D#B#C#.#
#   #A#B#C#A#
#   #########
#
# #############
# #AA.D.....AD#
# ###B#.#C#.###
#   #D#B#C#.#
#   #D#B#C#.#
#   #A#B#C#.#
#   #########
#
# #############
# #AA.......AD#
# ###B#.#C#.###
#   #D#B#C#.#
#   #D#B#C#.#
#   #A#B#C#D#
#   #########
#
# #############
# #AA.......AD#
# ###.#B#C#.###
#   #D#B#C#.#
#   #D#B#C#.#
#   #A#B#C#D#
#   #########
#
# #############
# #AA.......AD#
# ###.#B#C#.###
#   #.#B#C#.#
#   #D#B#C#D#
#   #A#B#C#D#
#   #########
#
# #############
# #AA.D.....AD#
# ###.#B#C#.###
#   #.#B#C#.#
#   #.#B#C#D#
#   #A#B#C#D#
#   #########
#
# #############
# #A..D.....AD#
# ###.#B#C#.###
#   #.#B#C#.#
#   #A#B#C#D#
#   #A#B#C#D#
#   #########
#
# #############
# #...D.....AD#
# ###.#B#C#.###
#   #A#B#C#.#
#   #A#B#C#D#
#   #A#B#C#D#
#   #########
#
# #############
# #.........AD#
# ###.#B#C#.###
#   #A#B#C#D#
#   #A#B#C#D#
#   #A#B#C#D#
#   #########
#
# #############
# #..........D#
# ###A#B#C#.###
#   #A#B#C#D#
#   #A#B#C#D#
#   #A#B#C#D#
#   #########
#
# #############
# #...........#
# ###A#B#C#D###
#   #A#B#C#D#
#   #A#B#C#D#
#   #A#B#C#D#
#   #########
#
# Using the initial configuration from the full diagram, what is the least energy required to organize the amphipods?
#
# Your puzzle answer was 47328.

def problem23(records : Array(String))
  positions = Array(Char).new(19, '.')

  i = 0
  records[1].strip.chars[1..-2].each do |a|
    positions[i] = a
    i += 1
  end

  i = 11
  records[2].strip.split(/#+/).compact.each do |a|
    next if a.empty? || a == "  "
    positions[i] = a[0]
    i += 1
  end

  records[3].strip.split(/#+/).compact.each do |a|
    next if a.empty? || a == "  "
    positions[i] = a[0]
    i += 1
  end

  organize_amphipods(positions)
end

def organize_amphipods(positions, ident = "", cache = Hash(String, Int32).new, min = -1)
  if ident.size > 2000
    print_amphipods_position(positions)
    raise "stack overflow"
    return -1
  end

  cache_key = positions.join
  if cache.has_key?(cache_key)
    return cache[cache_key]
  end

  size = positions.size

  correct = ['A', 'B', 'C', 'D']
  costs = {
    'A' => 1,
    'B' => 10,
    'C' => 100,
    'D' => 1000,
  }
  if positions[11..].in_groups_of(4).all? { |c| c == correct }
    cache[cache_key] = 0
    return 0
  end

  result = 1000000000
  result_position = Array(Char).new(19, '.')
  no_moves = true

  # print_amphipods_position(positions, ident)

  (11..size - 1).each_with_index do |absolute_pos, indx|
    c = positions[absolute_pos]
    next if c == '.'

    moves_to_hallway = (indx / 4).to_i32 + 1
    pos = indx % 4
    hallway_exit = pos * 2 + 2

    if correct.index(c).not_nil! == pos
      path = Array(Char).new
      i = absolute_pos
      while i < positions.size
        path << positions[i]
        i += 4
      end
      if path.uniq == [c]
        # puts "#{ident}#{c} in #{absolute_pos} / #{pos} the exit #{hallway_exit} with #{moves_to_hallway} already in correct position"
        next
      end
    end

    if moves_to_hallway > 1
      path = Array(Char).new
      1.upto(moves_to_hallway - 1) do |i|
        path << positions[absolute_pos - 4*i] == '.'
      end
      next if path.uniq != ['.']
    end
    possible_moves = [] of Int32

    # check for empty slot in hallways
    positions[0..10].each_with_index do |h, i|
      next if [2, 4, 6, 8].includes?(i)
      next if h != '.'
      if i > hallway_exit
        next if positions[hallway_exit..i].uniq != ['.']
      else
        next if positions[i..hallway_exit].uniq != ['.']
      end
      possible_moves << i
    end

    cost = costs[c]
    possible_moves.each do |next_pos|
      next_positions = positions.dup
      next_positions[absolute_pos] = '.'
      next_positions[next_pos] = c

      moves = moves_to_hallway + (next_pos - hallway_exit).abs
      r = moves * cost

      # puts "#{ident}from room to hallway #{c} in #{absolute_pos} the exit #{hallway_exit} with #{moves_to_hallway} to position #{next_pos}: cost #{r}"

      next if result != -1 && r > result

      m = -1
      m = organize_amphipods(next_positions, ident + "  ", cache)

      next if m == -1

      no_moves = false
      r += m
      if result == -1 || r < result
        result_position = next_positions
        result = r
      end
    end
  end

  # from hallway to room
  (0..10).each do |pos|
    next if [2, 4, 6, 8].includes?(pos)
    c = positions[pos]
    next if c == '.'

    # puts "#{ident}check #{c}[#{pos}] in hallway"
    letter_ident = correct.index(c).not_nil!
    hallway_exit = correct.index(c).not_nil! * 2 + 2
    # puts "#{ident}hallway_exit: #{hallway_exit}"

    if pos > hallway_exit
      # puts "hallway path:", positions[hallway_exit..pos-1]
      next if positions[hallway_exit..pos - 1].uniq != ['.']
    else
      # puts "hallway path:", positions[pos+1..hallway_exit]
      next if positions[pos + 1..hallway_exit].uniq != ['.']
    end

    moves_in_hallway = (pos - hallway_exit).abs

    # puts "#{ident}moves_in_hallway: #{moves_in_hallway}"

    possible_moves = [] of Int32

    i = 11 + letter_ident
    while i < positions.size
      pc = positions[i]
      # puts "#{ident}check position: #{i} -> #{pc}"
      break if pc != '.'
      possible_moves = [i]
      i += 4
    end
    # puts "#{ident}possible_moves: #{possible_moves}"

    empty_room = true
    while i < positions.size
      if positions[i] != c
        empty_room = false
        break
      end
      i += 4
    end
    next if !empty_room

    cost = costs[c]
    possible_moves.each do |next_pos|
      next_positions = positions.dup
      next_positions[pos] = '.'
      next_positions[next_pos] = c

      moves = moves_in_hallway + ((next_pos - hallway_exit - 2) / 4).to_i32

      # puts "#{ident}moves #{moves}"
      # raise "stop"
      r = moves * cost

      next if result != -1 && r > result

      # puts "#{ident}from hallway to room #{c} in #{pos} to exit #{hallway_exit} room in #{next_pos}: cost #{r}"

      m = -1
      m = organize_amphipods(next_positions, ident + "  ", cache)

      next if m == -1
      no_moves = false
      r += m
      if result == -1 || r < result
        result_position = next_positions
        result = r
      end
    end
  end

  if no_moves
    # puts "#{ident}No moves happen!"
    cache[cache_key] = -1
    return -1
  end

  cache[cache_key] = result
  return result
end

def print_amphipods_position(positions, ident = "")
  puts <<-EOL
  #{ident}#############
  #{ident}##{positions[0..10].join}#
  #{ident}####{positions[11..14].join("#")}###
  EOL

  positions[15..].in_groups_of(4).each do |g|
    puts "#{ident}  ##{g.join("#")}#"
  end
  puts "#{ident}  #########"
end

def problem23_part_two(records : Array(String))
  positions = Array(Char).new(27, '.')

  i = 0
  records[1].strip.chars[1..-2].each do |a|
    positions[i] = a
    i += 1
  end

  records[2].strip.split(/#+/).compact.each do |a|
    next if a.empty? || a == "  "
    positions[i] = a[0]
    i += 1
  end

  ['D', 'C', 'B', 'A'].each do |c|
    positions[i] = c
    i += 1
  end

  ['D', 'B', 'A', 'C'].each do |c|
    positions[i] = c
    i += 1
  end

  records[3].strip.split(/#+/).compact.each do |a|
    next if a.empty? || a == "  "
    positions[i] = a[0]
    i += 1
  end

  organize_amphipods(positions)
end
