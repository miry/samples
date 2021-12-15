def print_matrix(arr, format_cell = "%-3s", sep = "", output = STDOUT)
  print_matrix(arr, format_cell, sep, output) { |c| c }
end

def print_matrix(arr, format_cell = "%-3s", sep = "", output = STDOUT)
  arr.each_with_index do |row, ri|
    r = [] of String
    row.each_with_index do |cell, ci|
      cell_mod = yield cell, ri, ci
      r << (format_cell % [cell_mod])
    end
    output.puts r.join(sep)
  end

  return NoReturn
end
