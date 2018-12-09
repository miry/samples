# frozen_string_literal: false

require 'minitest/autorun'

require_relative 'reverse_words.rb'

class ReverseWordsTest < Minitest::Test
  def test_with_nil
    assert_nil reverse_words(nil)
  end

  def test_with_empty
    assert_equal '', reverse_words('')
  end

  def test_with_one_word
    assert_equal 'one', reverse_words('one')
  end

  def test_with_multiple_one_letter_words
    assert_equal 'b a', reverse_words('a b')
  end

  def test_with_multiple_two_letters_words
    assert_equal 'cd ab', reverse_words('ab cd')
  end

  def test_with_two_words
    assert_equal 'two one', reverse_words('one two')
  end

  def test_with_two_words_and_trailing_space
    assert_equal 'two one ', reverse_words(' one two')
  end

  def test_with_two_words_and_head_trailing_space
    assert_equal ' two one', reverse_words('one two ')
  end

  def test_with_two_words_and_trailing_spaces
    assert_equal ' two one ', reverse_words(' one two ')
  end

  def test_inplace
    subject = ' one two '
    result = reverse_words(subject)
    assert_equal result.object_id, subject.object_id
  end
end
