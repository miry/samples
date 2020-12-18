# https://adventofcode.com/2020/day/18

# --- Day 18: Operation Order ---

# As you look out the window and notice a heavily-forested continent slowly appear over the horizon, you are interrupted by the child sitting next to you. They're curious if you could help them with their math homework.

# Unfortunately, it seems like this "math" follows different rules than you remember.

# The homework (your puzzle input) consists of a series of expressions that consist of addition (+), multiplication (*), and parentheses ((...)). Just like normal math, parentheses indicate that the expression inside must be evaluated before it can be used by the surrounding expression. Addition still finds the sum of the numbers on both sides of the operator, and multiplication still finds the product.

# However, the rules of operator precedence have changed. Rather than evaluating multiplication before addition, the operators have the same precedence, and are evaluated left-to-right regardless of the order in which they appear.

# For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are as follows:

# 1 + 2 * 3 + 4 * 5 + 6
#   3   * 3 + 4 * 5 + 6
#       9   + 4 * 5 + 6
#          13   * 5 + 6
#              65   + 6
#                  71

# Parentheses can override this order; for example, here is what happens if parentheses are added to form 1 + (2 * 3) + (4 * (5 + 6)):

# 1 + (2 * 3) + (4 * (5 + 6))
# 1 +    6    + (4 * (5 + 6))
#      7      + (4 * (5 + 6))
#      7      + (4 *   11   )
#      7      +     44
#             51

# Here are a few more examples:

#     2 * 3 + (4 * 5) becomes 26.
#     5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 437.
#     5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 12240.
#     ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 13632.

# Before you can help with the homework, you need to understand it yourself. Evaluate the expression on each line of the homework; what is the sum of the resulting values?

# Your puzzle answer was 8298263963837.
# --- Part Two ---

# You manage to answer the child's questions and they finish part 1 of their homework, but get stuck when they reach the next section: advanced math.

# Now, addition and multiplication have different precedence levels, but they're not the ones you're familiar with. Instead, addition is evaluated before multiplication.

# For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are now as follows:

# 1 + 2 * 3 + 4 * 5 + 6
#   3   * 3 + 4 * 5 + 6
#   3   *   7   * 5 + 6
#   3   *   7   *  11
#      21       *  11
#          231

# Here are the other examples from above:

#     1 + (2 * 3) + (4 * (5 + 6)) still becomes 51.
#     2 * 3 + (4 * 5) becomes 46.
#     5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 1445.
#     5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 669060.
#     ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 23340.

# What do you get if you add up the results of evaluating the homework problems using these new rules?

# Your puzzle answer was 145575710203332.

class Calculator
  property exp : String

  def initialize(@exp)
  end

  def self.sum(exps)
    result = 0_i64
    exps.each do |exp|
      result += self.new(exp).perform
    end
    result
  end

  def perform
    result = 0_i64
    return result if exp.empty?
    rules = parse(@exp)
    rules = open_parentheses(rules)
    acc = rules[0].to_i64
    i = 1
    while i < rules.size
      op = rules[i]
      arg = rules[i + 1].to_i64
      case op
      when "+"
        acc += arg
      when "*"
        acc *= arg
      else
        raise "Unknown operation `#{op}`"
      end
      i += 2
    end
    acc
  end

  def parse(exp)
    rules = [] of String
    num = ""
    symbols = exp.chars + [' ']
    symbols.each do |sym|
      case sym
      when '0'..'9'
        num += sym
      when ' '
        rules << num if !num.empty?
        num = ""
      when '+', '*', '(', ')'
        if !num.empty?
          rules << num
          num = ""
        end
        rules << "#{sym}"
      else
        raise "Unknown symbol #{sym}"
      end
    end
    rules
  end

  def open_parentheses(rules)
    r = [] of String
    stack = [] of Int32
    rules.each do |rule|
      if rule == ")"
        i = stack.pop
        intermedia = r[i + 1..].join(' ')
        result = Calculator.new(intermedia).perform

        if i == 0
          r = [] of String
        else
          r = r[..i - 1]
        end

        r << result.to_s
      else
        stack << r.size if rule == "("
        r << rule
      end
    end
    r
  end
end

class Calculator2
  property exp : String

  def initialize(@exp)
  end

  def self.sum(exps)
    result = 0_i64
    exps.each do |exp|
      result += self.new(exp).perform
    end
    result
  end

  def perform
    result = 0_i64
    return result if exp.empty?
    rules = parse(@exp)
    rules = open_parentheses(rules)
    rules = first_pluses(rules)
    acc = rules[0].to_i64
    i = 1
    while i < rules.size
      op = rules[i]
      arg = rules[i + 1].to_i64
      case op
      when "+"
        acc += arg
      when "*"
        acc *= arg
      else
        raise "Unknown operation `#{op}`"
      end
      i += 2
    end
    acc
  end

  def parse(exp)
    rules = [] of String
    num = ""
    symbols = exp.chars + [' ']
    symbols.each do |sym|
      case sym
      when '0'..'9'
        num += sym
      when ' '
        rules << num if !num.empty?
        num = ""
      when '+', '*', '(', ')'
        if !num.empty?
          rules << num
          num = ""
        end
        rules << "#{sym}"
      else
        raise "Unknown symbol #{sym}"
      end
    end
    rules
  end

  def open_parentheses(rules)
    r = [] of String
    stack = [] of Int32
    rules.each_with_index do |rule, j|
      if rule == ")"
        i = stack.pop
        intermedia = r[i + 1..].join(' ')
        result = Calculator2.new(intermedia).perform

        if i == 0
          r = [] of String
        else
          r = r[..i - 1]
        end

        r << result.to_s
      else
        stack << r.size if rule == "("
        r << rule
      end
    end
    r
  end

  def first_pluses(rules)
    r = [] of String
    stack = [] of Int32

    j = 0
    while j < rules.size
      rule = rules[j]
      if rule == "+"
        i = r.size
        intermedia = r[-1] + " + " + rules[j + 1]
        if rules[j + 1] != '(' && rules[j + 1] != ')'
          result = r[-1].to_i64 + rules[j + 1].to_i64
        else
          result = Calculator2.new(intermedia).perform
        end
        r[-1] = result.to_s
        j += 2
      else
        r << rule
        j += 1
      end
    end
    r
  end
end
