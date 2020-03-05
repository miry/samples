# frozen_string_literal: true

require 'minitest/autorun'

require_relative 'array_nested.rb'

class ArrayNestedTest < Minitest::Test
  def test_with_not_array
    assert ![1,[1,1]].same_structure_as('string')
    assert ![1,[1,1]].same_structure_as(1)
    assert ![1,[1,1]].same_structure_as({})
  end

  def test_different_number_of_elements
    assert ![].same_structure_as([1])
    assert ![1,2].same_structure_as([1])
  end

  def test_only_numbers
    assert [2].same_structure_as([1])
    assert [2,3].same_structure_as([1,4])
  end

  def test_with_arrays_same_size
    assert [2, [1,3]].same_structure_as([1, [5,4]])
  end

  def test_with_mix_arrays_numbers
    assert ![2, 1, 3].same_structure_as([1, [5,4], 3])
    assert ![2, [1], 3].same_structure_as([1, 4, 3])
  end
end
