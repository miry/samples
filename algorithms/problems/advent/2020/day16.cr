# https://adventofcode.com/2020/day/16

# --- Day 16: Ticket Translation ---

# As you're walking to yet another connecting flight, you realize that one of the legs of your re-routed trip coming up is on a high-speed train. However, the train ticket you were given is in a language you don't understand. You should probably figure out what it says before you get to the train station after the next flight.

# Unfortunately, you can't actually read the words on the ticket. You can, however, read the numbers, and so you figure out the fields these tickets must have and the valid ranges for values in those fields.

# You collect the rules for ticket fields, the numbers on your ticket, and the numbers on other nearby tickets for the same train service (via the airport security cameras) together into a single document you can reference (your puzzle input).

# The rules for ticket fields specify a list of fields that exist somewhere on the ticket and the valid ranges of values for each field. For example, a rule like class: 1-3 or 5-7 means that one of the fields in every ticket is named class and can be any value in the ranges 1-3 or 5-7 (inclusive, such that 3 and 5 are both valid in this field, but 4 is not).

# Each ticket is represented by a single line of comma-separated values. The values are the numbers on the ticket in the order they appear; every ticket has the same format. For example, consider this ticket:

# .--------------------------------------------------------.
# | ????: 101    ?????: 102   ??????????: 103     ???: 104 |
# |                                                        |
# | ??: 301  ??: 302             ???????: 303      ??????? |
# | ??: 401  ??: 402           ???? ????: 403    ????????? |
# '--------------------------------------------------------'

# Here, ? represents text in a language you don't understand. This ticket might be represented as 101,102,103,104,301,302,303,401,402,403; of course, the actual train tickets you're looking at are much more complicated. In any case, you've extracted just the numbers in such a way that the first number is always the same specific field, the second number is always a different specific field, and so on - you just don't know what each position actually means!

# Start by determining which tickets are completely invalid; these are tickets that contain values which aren't valid for any field. Ignore your ticket for now.

# For example, suppose you have the following notes:

# class: 1-3 or 5-7
# row: 6-11 or 33-44
# seat: 13-40 or 45-50

# your ticket:
# 7,1,14

# nearby tickets:
# 7,3,47
# 40,4,50
# 55,2,20
# 38,6,12

# It doesn't matter which position corresponds to which field; you can identify invalid nearby tickets by considering only whether tickets contain values that are not valid for any field. In this example, the values on the first nearby ticket are all valid for at least one field. This is not true of the other three nearby tickets: the values 4, 55, and 12 are are not valid for any field. Adding together all of the invalid values produces your ticket scanning error rate: 4 + 55 + 12 = 71.

# Consider the validity of the nearby tickets you scanned. What is your ticket scanning error rate?

# Your puzzle answer was 27911.
# --- Part Two ---

# Now that you've identified which tickets contain invalid values, discard those tickets entirely. Use the remaining valid tickets to determine which field is which.

# Using the valid ranges for each field, determine what order the fields appear on the tickets. The order is consistent between all tickets: if seat is the third field, it is the third field on every ticket, including your ticket.

# For example, suppose you have the following notes:

# class: 0-1 or 4-19
# row: 0-5 or 8-19
# seat: 0-13 or 16-19

# your ticket:
# 11,12,13

# nearby tickets:
# 3,9,18
# 15,1,5
# 5,14,9

# Based on the nearby tickets in the above example, the first position must be row, the second position must be class, and the third position must be seat; you can conclude that in your ticket, class is 12, row is 11, and seat is 13.

# Once you work out which field is which, look for the six fields on your ticket that start with the word departure. What do you get if you multiply those six values together?

# Your puzzle answer was 737176602479.

class TicketTranslation
  property rules :  Hash(String, Array(Tuple(Int64, Int64)))
  property your_tickets : Array(Array(Int64))
  property nearby_tickets : Array(Array(Int64))

  def initialize(@rules, @your_tickets, @nearby_tickets)

  end

  def self.parse(lines) : self
    rules = Hash(String, Array(Tuple(Int64, Int64))).new
    i = 0
    line = lines[i]
    while line != ""
      rule = parse_rule(line)
      rules[rule[0]] = rule[1]
      i += 1
      line = lines[i]
    end

    your_tickets = Array(Array(Int64)).new
    i += 2 # skip label "your ticket:"
    line = lines[i]
    while line != ""
      your_tickets << line.split(',').map(&.to_i64)
      i += 1
      line = lines[i]
    end

    nearby_tickets = Array(Array(Int64)).new
    i += 2 # skip label "nearby ticket:"
    line = lines[i]
    n = lines.size
    while line != ""
      nearby_tickets << line.split(',').map(&.to_i64)
      i += 1
      break if i == n
      line = lines[i]
    end

    self.new(rules, your_tickets, nearby_tickets)
  end

  def valid_tickets
    result = Array(Array(Int64)).new
    @nearby_tickets.each do |ticket|
      invalid = false
      ticket.each_with_index do |field, field_id|
        valid = rules.values.flatten.any? do |range|
          field >= range[0] && field <= range[1]
        end
        if !valid
          invalid = true
          break
        end
      end
      result << ticket if !invalid
    end
    result
  end

  def detect_column(tickets)
    classified_columns = Array(String).new(tickets[0].size) {""}
    global_rs = rules.keys.dup
    count = 0
    while count < classified_columns.size
      tickets[0].size.times do |field_id|
        next if !classified_columns[field_id].empty?
        rs = global_rs
        new_rs = rs.dup
        tickets.each do |ticket|
          puts "validate ticket : #{ticket} column #{field_id} "
          field = ticket[field_id]
          p field
          rs.each do |rule_name|
            ranges = rules[rule_name]
            valid = ranges.any? do |range|
              field >= range[0] && field <= range[1]
            end
            if !valid
              p "invalid #{rule_name}"
              new_rs = new_rs.reject {|r| r == rule_name }
            end
          end
        end
        if new_rs.size == 1
          count += 1
          classified_columns[field_id] = new_rs[0]
          global_rs = global_rs.reject {|r| r == new_rs[0] }
        end
      end
    end
    classified_columns
  end

  def error_rate
    invalid = [] of Int64
    @nearby_tickets.each do |ticket|
      ticket.each_with_index do |field, field_id|
        valid = rules.values.flatten.any? do |range|
          field >= range[0] && field <= range[1]
        end
        invalid << field if !valid
      end
    end
    return 0 if invalid.empty?
    invalid.reduce {|a,i| a + i }
  end

  def departure_mul
    rules_by_field_id = detect_column valid_tickets
    result = 1_i64
    rules_by_field_id.each_with_index do |rule_name, field_id|
      if rule_name.includes?("departure")
        result *= your_tickets[0][field_id]
      end
    end
    result
  end

  def self.parse_rule(rule)
    field, ranges_raw = rule.split(": ")
    ranges_chunks = ranges_raw.split(" or ")
    ranges = ranges_chunks.map {|chunk| v = chunk.split('-'); {v[0].to_i64, v[1].to_i64}}
    {field, ranges}
  end
end
