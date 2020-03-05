# frozen_string_literal: true

# https://ruby-doc.org/core-2.7.0/Array.html
class Array
  def same_structure_as(other)
    return false unless other.is_a?(Array)

    s1 = size
    s2 = other.size

    return false if s1 != s2

    s1.times do |i|
      e1 = self[i]
      e2 = other[i]
      is_arr1 = e1.is_a?(Array)
      is_arr2 = e2.is_a?(Array)

      if is_arr1
        return false unless e1.same_structure_as(e2)
      elsif is_arr1 || is_arr2
        return false
      end
    end

    return true
  end
end
