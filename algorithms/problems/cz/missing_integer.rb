=begin
that, given an array A of N integers, returns the smallest positive integer (greater than 0) that does not occur in A.
=end
def missing_integer(a)
  result = []
  a.each do |i|
    result[i] = i if i > 0
  end

  i = 1
  while result[i] != nil
    i += 1
  end
  i
end
