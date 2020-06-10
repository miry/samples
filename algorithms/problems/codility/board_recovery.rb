# frozen_string_literal: true

def board_recovery(u, l, c)

  matrix = values_of_matrix u, l, c
  return "IMPOSSIBLE" unless matrix

  matrix[0].join("") + "," + matrix[1].join("")
end

def check_sums(u, l, c)
  (u + l) == c.reduce(:+)
end


def values_of_matrix(u, l, c)
  if c.size == 0
    if (u == 0) && (l == 0)
      return [[],[]]
    end

    return false
  end

  return false unless check_sums(u, l, c)

  # if both 0 for firts column
  result = values_of_matrix(u, l, c[1..-1]) 
  if result
    result[0].insert(0,0)
    result[1].insert(0,0)
    return result
  end

  if u > 0
  result = values_of_matrix(u-1, l, c[1..-1]) 
  if result
    result[0].insert(0,1)
    result[1].insert(0,0)
    return result
  end
  end

  if l > 0
  result = values_of_matrix(u, l-1, c[1..-1]) 
  if result
    result[0].insert(0,0)
    result[1].insert(0,1)
    return result
  end
  end

  if u > 0 && l > 0
  result = values_of_matrix(u-1, l-1, c[1..-1]) 
  if result
    result[0].insert(0, 1)
    result[1].insert(0, 1)
    return result
  end
  end

  return false
end
