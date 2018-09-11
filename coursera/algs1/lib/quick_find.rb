class QuickFindUF

  attr_reader :ids

  def initialize(n)
    @ids = (0...n).to_a
  end

  def union(p, q)
    pid = @ids[p]
    qid = @ids[q]

    @ids.map! do |i|
      i == pid ? qid : i
    end
  end

  def unions(values)
    values.each do |union_values|
      union(*union_values)
    end
  end

  def to_s
    ids.join(" ")
  end
end


if __FILE__ == $0
  puts "Input the number of items (10): "
  number = gets.to_i
  number = 10 if number <= 0
  quick_finder = QuickFindUF.new(number)

  puts "Input unions(ex: 9-4 6-4 2-5): "
  unions_string = gets.split(' ').map{|i| i.split('-').map(&:to_i) }

  quick_finder.unions(unions_string)

  puts "Result: %s" % quick_finder
end
