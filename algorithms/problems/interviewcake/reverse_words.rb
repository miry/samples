=begin
You're working on a secret team solving coded transmissions.

Your team is scrambling to decipher a recent message, worried it's a plot to break into a major European National Cake Vault. The message has been mostly deciphered, but all the words are backward! Your colleagues have handed off the last step to you.

Write a method `reverse_words()` that takes a message as a string and reverses the order of the words in place.

For example:

    message = 'cake pound steal'
    reverse_words(message)
    puts message
    # prints: 'steal pound cake'

When writing your method, assume the message contains only letters and spaces, and all words are separated by one space.
=end

def reverse_words(str)
  return str if str == nil || str == ''

  n = str.size
  word_start = 0
  word_finish = 0

  while word_finish < n
    if str[word_finish] != ' '
      word_finish += 1
      next
    end

    reverse(str, word_start, word_finish-1)
    word_finish += 1
    word_start = word_finish
  end

  reverse(str, word_start, word_finish-1)
  reverse(str, 0, n-1)
  str
end

def reverse(str, start, finish)
  return if finish <= start
  i = start
  j = finish
  while i < j
    t = str[i]
    str[i] = str[j]
    str[j] = t
    i += 1
    j -= 1
  end
end
