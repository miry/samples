# https://adventofcode.com/2019/day/8
#
# --- Day 8: Space Image Format ---
#
# The Elves' spirits are lifted when they realize you have an opportunity to reboot one of their Mars rovers, and so they are curious if you would spend a brief sojourn on Mars. You land your ship near the rover.
#
# When you reach the rover, you discover that it's already in the process of rebooting! It's just waiting for someone to enter a BIOS password. The Elf responsible for the rover takes a picture of the password (your puzzle input) and sends it to you via the Digital Sending Network.
#
# Unfortunately, images sent via the Digital Sending Network aren't encoded with any normal encoding; instead, they're encoded in a special Space Image Format. None of the Elves seem to remember why this is the case. They send you the instructions to decode it.
#
# Images are sent as a series of digits that each represent the color of a single pixel. The digits fill each row of the image left-to-right, then move downward to the next row, filling rows top-to-bottom until every pixel of the image is filled.
#
# Each image actually consists of a series of identically-sized layers that are filled in this way. So, the first digit corresponds to the top-left pixel of the first layer, the second digit corresponds to the pixel to the right of that on the same layer, and so on until the last digit, which corresponds to the bottom-right pixel of the last layer.
#
# For example, given an image 3 pixels wide and 2 pixels tall, the image data 123456789012 corresponds to the following image layers:
#
# Layer 1: 123
#          456
#
# Layer 2: 789
#          012
#
# The image you received is 25 pixels wide and 6 pixels tall.
#
# To make sure the image wasn't corrupted during transmission, the Elves would like you to find the layer that contains the fewest 0 digits. On that layer, what is the number of 1 digits multiplied by the number of 2 digits?
#

class NetworkImage
  @layers : Array(Array(Char?))

  def initialize(@width : Int64, @height : Int64, @pixels : String)
    @layers = layers
  end

  def layers
    result = [] of String
    i = 0
    n = @pixels.size
    @pixels.chars.in_groups_of(@width * @height)
  end

  def layer_with_fewest_null
    min = {-1, @width * @height}
    @layers.each_with_index do |layer, i|
      nums = numbers_in(layer)
      num0 = nums.has_key?('0') ? nums['0'] : 0
      if min[1] > num0
        min = {i, num0}
      end
    end
    return [] of Char if min[0] == -1
    @layers[min[0]]
  end

  def seed(layer : Array(Char?))
    numbers = numbers_in(layer)

    num1 = numbers.has_key?('1') ? numbers['1'] : 0
    num2 = numbers.has_key?('2') ? numbers['2'] : 0
    num1 * num2
  end

  def numbers_in(layer : Array(Char?))
    result = {} of Char => Int64
    layer.each do |d|
      next if d.nil?
      if result.has_key?(d.not_nil!) && !result[d.not_nil!].nil?
        result[d.not_nil!] += 1
      else
        result[d.not_nil!] = 1
      end
    end
    result
  end

  def image_seed
    layer = layer_with_fewest_null
    seed(layer)
  end
end
