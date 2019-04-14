def line(width)
  return if width  <= 0
  print '_'*width
end

def line_with_vertical(delimeter)
  line(delimeter)
  print '1'
  line(delimeter - 1)
end

def line_shrag(size,i)
  line(size*2-i+1)
  print '1'
  line(2*i + 1)
  print '1'
  line(size*2-i)
end

def piece(margin, limit, quantity)
  size=limit/quantity

  (size-1).downto(0) do |i|
    line(margin-1)
    quantity.times do
      line_shrag(size-1,i)
    end
    line(margin+1)
    puts
  end

  size.times do
    line(margin-1)
    quantity.times do
      line_with_vertical(size*2)
    end
    line(margin+1)
    puts
  end
end

def empty_piece(width, lines)
  lines.times do
    line(width)
    puts
  end
end

MAX=4
WIDTH=100
N=5

width=WIDTH
center=width/2
max_width=2**MAX
padding=max_width/(1-0.5)
margin=center-padding

empty_piece(width,1)

MAX.downto(0) do |i|
  if i < N
    piece(margin, max_width, 2**i)
  else
    empty_piece(width, 2**(MAX-i))
  end
end

puts
