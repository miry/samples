class Calculator
  PRIORITY = {
    '+' => 1,
    '-' => 1,
    '*' => 2,
    '/' => 2,
  }

  def evaluate(expr)
    elements = expr.split(' ')
    eval(elements)
  end

  def eval(elements)
    n = elements.size
    return elements[0].to_i if n == 1

    i = 0
    left = elements[i].to_i
    while i < n - 2 do
      operator = elements[i+1]
      right = elements[i+2].to_i
      next_operator = elements[i+3]

      if next_operator && PRIORITY[operator] < PRIORITY[next_operator]
        if operator == '-'
          operator = '+'
          elements[i+2] = "-#{elements[i+2]}"
        end
        right = eval(elements[i+2..-1])
        return process(left, right, operator)
      end

      left = process(left, right, operator)
      i += 2
    end
    left
  end

  def process(a, b, operator)
    case operator
    when '+'
      return a + b
    when '-'
      return a - b
    when '*'
      return a * b
    when '/'
      return a.to_f / b.to_f
    end
  end
end
