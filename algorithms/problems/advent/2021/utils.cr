def print_matrix(arr, format_cell = "%-3s", sep = "", output = STDOUT)
  print_matrix(arr, format_cell, sep, output) { |c| c }
end

def print_matrix(arr, format_cell = "%-3s", sep = "", output = STDOUT)
  arr.each do |row|
    r = [] of String
    row.each do |cell|
      cell_mod = yield cell
      r << (format_cell % [cell_mod])
    end
    output.puts r.join(sep)
  end

  return NoReturn
end
