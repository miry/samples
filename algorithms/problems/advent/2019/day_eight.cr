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
# --- Part Two ---
#
# Now you're ready to decode the image. The image is rendered by stacking the layers and aligning the pixels with the same positions in each layer. The digits indicate the color of the corresponding pixel: 0 is black, 1 is white, and 2 is transparent.
#
# The layers are rendered with the first layer in front and the last layer in back. So, if a given position has a transparent pixel in the first and second layers, a black pixel in the third layer, and a white pixel in the fourth layer, the final image would have a black pixel at that position.
#
# For example, given an image 2 pixels wide and 2 pixels tall, the image data 0222112222120000 corresponds to the following image layers:
#
# Layer 1: 02
#          22
#
# Layer 2: 11
#          22
#
# Layer 3: 22
#          12
#
# Layer 4: 00
#          00
#
# Then, the full image can be found by determining the top visible pixel in each position:
#
#     The top-left pixel is black because the top layer is 0.
#     The top-right pixel is white because the top layer is 2 (transparent), but the second layer is 1.
#     The bottom-left pixel is white because the top two layers are 2, but the third layer is 1.
#     The bottom-right pixel is black because the only visible pixel in that position is 0 (from layer 4).
#
# So, the final image looks like this:
#
# 01
# 10
#
# What message is produced after decoding your image?

class Layer
  property pixels : Array(Char | Nil)

  def initialize(@width : Int64, @height : Int64, @pixels : Array(Char | Nil))
    raise "Wrong data #{@width}x#{@height} is not #{@pixels.size}" unless @pixels.size == @width*@height
  end

  def mask(other)
    result = @pixels.dup
    result.each_with_index do |color, i|
      if color == '2'
        result[i] = other.pixels[i]
      end
    end
    Layer.new(@width, @height, result)
  end

  def print
    puts "\n===="
    @pixels.in_groups_of(@width).each do |line|
      line.each do |c|
        case c
        when '0'
          print(' ')
        when '1'
          print('1')
        when '2'
          print ' '
        end
      end
      puts
    end
  end
end

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

  def compute_layer
    ll = Array.new(@layers.size) { |i| Layer.new @width, @height, @layers[i] }
    result = ll[0]
    ll.each do |layer|
      result = result.mask(layer)
    end
    result
  end
end
