class WQuickFindUF

  attr_reader :ids

  def initialize(n)
    @ids = (0...n).to_a
    @sizes = {}
  end

  def union(p, q)
    pid = root(p)
    qid = root(q)

    p_size = size(pid)
    q_size = size(qid)
    new_root, old_root = p_size >= q_size ? [pid, qid] : [qid, pid]

    @ids[old_root] = new_root
    @sizes[new_root] = p_size + q_size
  end

  def unions(values)
    values.each do |union_values|
      union(*union_values)
    end
  end

  def connected?(p, q)
    root(p) == root(q)
  end

  def root(i)
    result = i
    while(result != @ids[result])
      result = @ids[result]
    end
    result
  end

  def size(i)
    @sizes[root(i)] || 1
  end

  def to_s
    ids.join(" ")
  end
end

if __FILE__ == $0
  puts "Input the number of items (10): "
  number = gets.to_i
  number = 10 if number <= 0
  quick_finder = WQuickFindUF.new(number)

  puts "Input unions(ex: 9-4 6-4 2-5): "
  unions_string = gets.split(' ').map{|i| i.split('-').map(&:to_i) }

  quick_finder.unions(unions_string)

  puts "Result: %s" % quick_finder
end
