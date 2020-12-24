# https://adventofcode.com/2020/day/23

# --- Day 23: Crab Cups ---

# The small crab challenges you to a game! The crab is going to mix up some cups, and you have to predict where they'll end up.

# The cups will be arranged in a circle and labeled clockwise (your puzzle input). For example, if your labeling were 32415, there would be five cups in the circle; going clockwise around the circle from the first cup, the cups would be labeled 3, 2, 4, 1, 5, and then back to 3 again.

# Before the crab starts, it will designate the first cup in your list as the current cup. The crab is then going to do 100 moves.

# Each move, the crab does the following actions:

#     The crab picks up the three cups that are immediately clockwise of the current cup. They are removed from the circle; cup spacing is adjusted as necessary to maintain the circle.
#     The crab selects a destination cup: the cup with a label equal to the current cup's label minus one. If this would select one of the cups that was just picked up, the crab will keep subtracting one until it finds a cup that wasn't just picked up. If at any point in this process the value goes below the lowest value on any cup's label, it wraps around to the highest value on any cup's label instead.
#     The crab places the cups it just picked up so that they are immediately clockwise of the destination cup. They keep the same order as when they were picked up.
#     The crab selects a new current cup: the cup which is immediately clockwise of the current cup.

# For example, suppose your cup labeling were 389125467. If the crab were to do merely 10 moves, the following changes would occur:

# -- move 1 --
# cups: (3) 8  9  1  2  5  4  6  7
# pick up: 8, 9, 1
# destination: 2

# -- move 2 --
# cups:  3 (2) 8  9  1  5  4  6  7
# pick up: 8, 9, 1
# destination: 7

# -- move 3 --
# cups:  3  2 (5) 4  6  7  8  9  1
# pick up: 4, 6, 7
# destination: 3

# -- move 4 --
# cups:  7  2  5 (8) 9  1  3  4  6
# pick up: 9, 1, 3
# destination: 7

# -- move 5 --
# cups:  3  2  5  8 (4) 6  7  9  1
# pick up: 6, 7, 9
# destination: 3

# -- move 6 --
# cups:  9  2  5  8  4 (1) 3  6  7
# pick up: 3, 6, 7
# destination: 9

# -- move 7 --
# cups:  7  2  5  8  4  1 (9) 3  6
# pick up: 3, 6, 7
# destination: 8

# -- move 8 --
# cups:  8  3  6  7  4  1  9 (2) 5
# pick up: 5, 8, 3
# destination: 1

# -- move 9 --
# cups:  7  4  1  5  8  3  9  2 (6)
# pick up: 7, 4, 1
# destination: 5

# -- move 10 --
# cups: (5) 7  4  1  8  3  9  2  6
# pick up: 7, 4, 1
# destination: 3

# -- final --
# cups:  5 (8) 3  7  4  1  9  2  6

# In the above example, the cups' values are the labels as they appear moving clockwise around the circle; the current cup is marked with ( ).

# After the crab is done, what order will the cups be in? Starting after the cup labeled 1, collect the other cups' labels clockwise into a single string with no extra characters; each number except 1 should appear exactly once. In the above example, after 10 moves, the cups clockwise from 1 are labeled 9, 2, 6, 5, and so on, producing 92658374. If the crab were to complete all 100 moves, the order after cup 1 would be 67384529.

# Using your labeling, simulate 100 moves. What are the labels on the cups after cup 1?

# Your puzzle answer was 28793654.
# --- Part Two ---

# Due to what you can only assume is a mistranslation (you're not exactly fluent in Crab), you are quite surprised when the crab starts arranging many cups in a circle on your raft - one million (1000000) in total.

# Your labeling is still correct for the first few cups; after that, the remaining cups are just numbered in an increasing fashion starting from the number after the highest number in your list and proceeding one by one until one million is reached. (For example, if your labeling were 54321, the cups would be numbered 5, 4, 3, 2, 1, and then start counting up from 6 until one million is reached.) In this way, every number from one through one million is used exactly once.

# After discovering where you made the mistake in translating Crab Numbers, you realize the small crab isn't going to do merely 100 moves; the crab is going to do ten million (10000000) moves!

# The crab is going to hide your stars - one each - under the two cups that will end up immediately clockwise of cup 1. You can have them if you predict what the labels on those cups will be when the crab is finished.

# In the above example (389125467), this would be 934001 and then 159792; multiplying these together produces 149245887792.

# Determine which two cups will end up immediately clockwise of cup 1. What do you get if you multiply their labels together?

# Your puzzle answer was 359206768694.

class DoubleLinkedListNode
  property value : Int32
  property parent : DoubleLinkedListNode | Nil
  property child : DoubleLinkedListNode | Nil

  def initialize(@value, @parent)
  end

  def set_child(new_child : DoubleLinkedListNode)
    @child = new_child
    new_child.parent = self
  end

  def child
    @child.not_nil!
  end

  def parent
    @parent.not_nil!
  end

  def childs
    node = self.child
    result = [] of Int32
    while node.value != value
      result << node.value
      node = node.child
    end
    result
  end
end

class Cups
  property list_root : DoubleLinkedListNode
  property index : Hash(Int32, DoubleLinkedListNode)
  property min : Int32
  property max : Int32

  def initialize(items : Array(Int32))
    @index = Hash(Int32, DoubleLinkedListNode).new
    parent = DoubleLinkedListNode.new(items[0], nil)
    @list_root = parent
    @index[items[0]] = parent
    @min = items[0]
    @max = items[0]

    i = 1
    n = items.size
    while i < n
      val = items[i]
      @min = val if @min > val
      @max = val if @max < val
      child = DoubleLinkedListNode.new(val, parent)
      parent.set_child child
      parent = child
      @index[val] = child
      i += 1
    end
    parent.set_child @list_root
  end

  def move(dest_val, new_items)
    dest_node = @index[dest_val]

    old_parent = new_items[0].parent
    old_parent.set_child new_items[-1].child.not_nil!

    old_child = dest_node.child.not_nil!
    dest_node.set_child new_items[0]
    new_items[-1].set_child old_child
  end

  def pick_up(count = 3)
    node = @list_root
    result = [] of DoubleLinkedListNode
    count.times do
      node = node.child.not_nil!
      result << node
    end
    result
  end

  def get
    @list_root.value
  end

  def next
    @list_root = @list_root.child.not_nil!
  end

  def size
    @index.size
  end
end

class CupGame
  property cups_list : Cups
  property current : Int32
  property min : Int32
  property max : Int32

  def initialize(cups : Array(Int32))
    @cups_list = Cups.new(cups)
    @current = 0
    @min = @cups_list.min
    @max = @cups_list.max
  end

  def play(moves)
    output = STDOUT

    moves.times do |i|
      # output.flush
      # output.printf("move %8d of %8d \r", i, moves)
      # output.flush
      # puts "=--- move #{i+1}"
      # puts
      round
      # puts
    end
  end

  def round
    current_value = @cups_list.get
    # puts "  cups: #{current_value} #{@cups_list.list_root.childs.join(" ")}"
    # puts "  current: #{current_value}"

    extracted_cups = @cups_list.pick_up(3)
    extracted_values = extracted_cups.map &.value
    # puts "  pick up: #{extracted_cups.map{|n| n.value}.join(" ")}"

    destination_cup = current_value - 1
    destination_cup = @max if destination_cup < @min
    while extracted_values.includes?(destination_cup)
      destination_cup -= 1
      destination_cup = @max if destination_cup < @min
    end
    # puts "  destination: #{destination_cup}"
    @cups_list.move(destination_cup, extracted_cups)
    @cups_list.next
  end

  def result
    node = @cups_list.index[1]
    node = node.child.not_nil!

    result = [] of Int32
    while node.value != 1
      result << node.value
      node = node.child.not_nil!
    end
    result.join("")
  end

  def found_star
    node = @cups_list.index[1]
    result = [] of Int32
    2.times do
      node = node.parent
      result << node.value
    end
    puts "parent:"
    puts result.join(" * ")

    node = @cups_list.index[1]
    result = [] of Int32
    2.times do
      node = node.child.not_nil!
      result << node.value
    end

    puts result.join(" * ")
    result[0].to_i64*result[1].to_i64
  end

  def self.parse(cups : String, max_count : Int32)
    cups_with_number = cups.split("").map &.to_i32
    if cups_with_number.size < max_count
      max = cups_with_number.max + 1
      (max_count - cups_with_number.size).times do |i|
        cups_with_number << max + i
      end
    end
    puts cups_with_number[..11].join(" ")
    self.new(cups_with_number)
  end
end

# 221741960076 too low
