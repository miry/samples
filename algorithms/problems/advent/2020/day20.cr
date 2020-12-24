# https://adventofcode.com/2020/day/20

# --- Day 20: Jurassic Jigsaw ---

# The high-speed train leaves the forest and quickly carries you south. You can even see a desert in the distance! Since you have some spare time, you might as well see if there was anything interesting in the image the Mythical Information Bureau satellite captured.

# After decoding the satellite messages, you discover that the data actually contains many small images created by the satellite's camera array. The camera array consists of many cameras; rather than produce a single square image, they produce many smaller square image tiles that need to be reassembled back into a single image.

# Each camera in the camera array returns a single monochrome image tile with a random unique ID number. The tiles (your puzzle input) arrived in a random order.

# Worse yet, the camera array appears to be malfunctioning: each image tile has been rotated and flipped to a random orientation. Your first task is to reassemble the original image by orienting the tiles so they fit together.

# To show how the tiles should be reassembled, each tile's image data includes a border that should line up exactly with its adjacent tiles. All tiles have this border, and the border lines up exactly when the tiles are both oriented correctly. Tiles at the edge of the image also have this border, but the outermost edges won't line up with any other tiles.

# For example, suppose you have the following nine tiles:

# Tile 2311:
# ..##.#..#.
# ##..#.....
# #...##..#.
# ####.#...#
# ##.##.###.
# ##...#.###
# .#.#.#..##
# ..#....#..
# ###...#.#.
# ..###..###

# Tile 1951:
# #.##...##.
# #.####...#
# .....#..##
# #...######
# .##.#....#
# .###.#####
# ###.##.##.
# .###....#.
# ..#.#..#.#
# #...##.#..

# Tile 1171:
# ####...##.
# #..##.#..#
# ##.#..#.#.
# .###.####.
# ..###.####
# .##....##.
# .#...####.
# #.##.####.
# ####..#...
# .....##...

# Tile 1427:
# ###.##.#..
# .#..#.##..
# .#.##.#..#
# #.#.#.##.#
# ....#...##
# ...##..##.
# ...#.#####
# .#.####.#.
# ..#..###.#
# ..##.#..#.

# Tile 1489:
# ##.#.#....
# ..##...#..
# .##..##...
# ..#...#...
# #####...#.
# #..#.#.#.#
# ...#.#.#..
# ##.#...##.
# ..##.##.##
# ###.##.#..

# Tile 2473:
# #....####.
# #..#.##...
# #.##..#...
# ######.#.#
# .#...#.#.#
# .#########
# .###.#..#.
# ########.#
# ##...##.#.
# ..###.#.#.

# Tile 2971:
# ..#.#....#
# #...###...
# #.#.###...
# ##.##..#..
# .#####..##
# .#..####.#
# #..#.#..#.
# ..####.###
# ..#.#.###.
# ...#.#.#.#

# Tile 2729:
# ...#.#.#.#
# ####.#....
# ..#.#.....
# ....#..#.#
# .##..##.#.
# .#.####...
# ####.#.#..
# ##.####...
# ##..#.##..
# #.##...##.

# Tile 3079:
# #.#.#####.
# .#..######
# ..#.......
# ######....
# ####.#..#.
# .#...#.##.
# #.#####.##
# ..#.###...
# ..#.......
# ..#.###...

# By rotating, flipping, and rearranging them, you can find a square arrangement that causes all adjacent borders to line up:

# #...##.#.. ..###..### #.#.#####.
# ..#.#..#.# ###...#.#. .#..######
# .###....#. ..#....#.. ..#.......
# ###.##.##. .#.#.#..## ######....
# .###.##### ##...#.### ####.#..#.
# .##.#....# ##.##.###. .#...#.##.
# #...###### ####.#...# #.#####.##
# .....#..## #...##..#. ..#.###...
# #.####...# ##..#..... ..#.......
# #.##...##. ..##.#..#. ..#.###...

# #.##...##. ..##.#..#. ..#.###...
# ##..#.##.. ..#..###.# ##.##....#
# ##.####... .#.####.#. ..#.###..#
# ####.#.#.. ...#.##### ###.#..###
# .#.####... ...##..##. .######.##
# .##..##.#. ....#...## #.#.#.#...
# ....#..#.# #.#.#.##.# #.###.###.
# ..#.#..... .#.##.#..# #.###.##..
# ####.#.... .#..#.##.. .######...
# ...#.#.#.# ###.##.#.. .##...####

# ...#.#.#.# ###.##.#.. .##...####
# ..#.#.###. ..##.##.## #..#.##..#
# ..####.### ##.#...##. .#.#..#.##
# #..#.#..#. ...#.#.#.. .####.###.
# .#..####.# #..#.#.#.# ####.###..
# .#####..## #####...#. .##....##.
# ##.##..#.. ..#...#... .####...#.
# #.#.###... .##..##... .####.##.#
# #...###... ..##...#.. ...#..####
# ..#.#....# ##.#.#.... ...##.....

# For reference, the IDs of the above tiles are:

# 1951    2311    3079
# 2729    1427    2473
# 2971    1489    1171

# To check that you've assembled the image correctly, multiply the IDs of the four corner tiles together. If you do this with the assembled tiles from the example above, you get 1951 * 3079 * 2971 * 1171 = 20899048083289.

# Assemble the tiles into an image. What do you get if you multiply together the IDs of the four corner tiles?

# Your puzzle answer was 13224049461431.
# --- Part Two ---

# Now, you're ready to check the image for sea monsters.

# The borders of each tile are not part of the actual image; start by removing them.

# In the example above, the tiles become:

# .#.#..#. ##...#.# #..#####
# ###....# .#....#. .#......
# ##.##.## #.#.#..# #####...
# ###.#### #...#.## ###.#..#
# ##.#.... #.##.### #...#.##
# ...##### ###.#... .#####.#
# ....#..# ...##..# .#.###..
# .####... #..#.... .#......

# #..#.##. .#..###. #.##....
# #.####.. #.####.# .#.###..
# ###.#.#. ..#.#### ##.#..##
# #.####.. ..##..## ######.#
# ##..##.# ...#...# .#.#.#..
# ...#..#. .#.#.##. .###.###
# .#.#.... #.##.#.. .###.##.
# ###.#... #..#.##. ######..

# .#.#.### .##.##.# ..#.##..
# .####.## #.#...## #.#..#.#
# ..#.#..# ..#.#.#. ####.###
# #..####. ..#.#.#. ###.###.
# #####..# ####...# ##....##
# #.##..#. .#...#.. ####...#
# .#.###.. ##..##.. ####.##.
# ...###.. .##...#. ..#..###

# Remove the gaps to form the actual image:

# .#.#..#.##...#.##..#####
# ###....#.#....#..#......
# ##.##.###.#.#..######...
# ###.#####...#.#####.#..#
# ##.#....#.##.####...#.##
# ...########.#....#####.#
# ....#..#...##..#.#.###..
# .####...#..#.....#......
# #..#.##..#..###.#.##....
# #.####..#.####.#.#.###..
# ###.#.#...#.######.#..##
# #.####....##..########.#
# ##..##.#...#...#.#.#.#..
# ...#..#..#.#.##..###.###
# .#.#....#.##.#...###.##.
# ###.#...#..#.##.######..
# .#.#.###.##.##.#..#.##..
# .####.###.#...###.#..#.#
# ..#.#..#..#.#.#.####.###
# #..####...#.#.#.###.###.
# #####..#####...###....##
# #.##..#..#...#..####...#
# .#.###..##..##..####.##.
# ...###...##...#...#..###

# Now, you're ready to search for sea monsters! Because your image is monochrome, a sea monster will look like this:

#                   #
# #    ##    ##    ###
#  #  #  #  #  #  #

# When looking for this pattern in the image, the spaces can be anything; only the # need to match. Also, you might need to rotate or flip your image before it's oriented correctly to find sea monsters. In the above image, after flipping and rotating it to the appropriate orientation, there are two sea monsters (marked with O):

# .####...#####..#...###..
# #####..#..#.#.####..#.#.
# .#.#...#.###...#.##.O#..
# #.O.##.OO#.#.OO.##.OOO##
# ..#O.#O#.O##O..O.#O##.##
# ...#.#..##.##...#..#..##
# #.##.#..#.#..#..##.#.#..
# .###.##.....#...###.#...
# #.####.#.#....##.#..#.#.
# ##...#..#....#..#...####
# ..#.##...###..#.#####..#
# ....#.##.#.#####....#...
# ..##.##.###.....#.##..#.
# #...#...###..####....##.
# .#.##...#.##.#.#.###...#
# #.###.#..####...##..#...
# #.###...#.##...#.##O###.
# .O##.#OO.###OO##..OOO##.
# ..O#.O..O..O.#O##O##.###
# #.#..##.########..#..##.
# #.#####..#.#...##..#....
# #....##..#.#########..##
# #...#.....#..##...###.##
# #..###....##.#...##.##.#

# Determine how rough the waters are in the sea monsters' habitat by counting the number of # that are not part of a sea monster. In the above example, the habitat's water roughness is 273.

# How many # are not part of a sea monster?

# Your puzzle answer was 2231.

class Tile
  property id : Int32
  property image : Array(Array(Char))
  property top : String, bottom : String, left : String, right : String

  MONSTER = [
    "                  # ".split(""),
    "#    ##    ##    ###".split(""),
    " #  #  #  #  #  #   ".split(""),
  ] of Array(String)

  MONSTER_PATTERN = [
    {0, 18},
    {1, 0}, {1, 5}, {1, 6}, {1, 11}, {1, 12}, {1, 17}, {1, 18}, {1, 19},
    {2, 1}, {2, 4}, {2, 7}, {2, 10}, {2, 13}, {2, 16},
  ]

  def initialize(@id, @image)
    @top = ""
    @left = ""
    @bottom = ""
    @right = ""
    if !@image.empty?
      @top = @image[0].join("")
      @bottom = @image[-1].join("")
      @left = @image.map { |rows| rows[0] }.join("")
      @right = @image.map { |rows| rows[-1] }.join("")
    end
  end

  def ==(other : self) : Bool
    @image.size.times do |row|
      return false if @image[row] != other.image[row]
    end
    true
  end

  def self.parse(raw : Array(String)) : Array(Tile)
    result = [] of self
    tile_id = 0
    image = Array(Array(Char)).new
    raw.each do |line|
      if line.includes?("Tile")
        tile_id = line[/[0-9]+/].not_nil!.to_i32
        image = Array(Array(Char)).new
      elsif line == ""
        result << self.new(tile_id, image)
        tile_id = 0
      else
        image << line.chars
      end
    end

    if tile_id != 0
      result << self.new(tile_id, image)
    end

    result.each do |tile|
      puts "\nTile #{tile.id}:"
      tile.print
    end

    return result
  end

  def self.assemble(tiles : Array(Tile))
    n = Math.sqrt(tiles.size).to_i32

    store = Hash(Int32, Array(Tile)).new
    tiles.each do |tile|
      store[tile.id] = tile.variants
    end

    empty_tile = Tile.new(0, Array(Array(Char)).new)
    square = Array(Array(Tile)).new(n)
    n.times do |row|
      square << Array(Tile).new(n, empty_tile)
    end

    result = build_square(square, store, 0, 0)
    puts "Build status: #{result}"

    puts "\nImage:"
    n.times do |row|
      puts square[row].map(&.id).join(" ")
    end
    puts ""

    square
  end

  def self.remove_borders(image : Array(Array(Tile)))
    image.each do |row|
      row.each &.remove_borders!
    end
  end

  def self.detect_monster(tiles : Array(Tile))
    image_tiles = assemble(tiles)
    remove_borders(image_tiles)

    image = Array(Array(Char)).new
    n = image_tiles.size
    n.times do |row|
      tile_size = image_tiles[row][0].image.size
      tile_size.times do |tile_row|
        image << image_tiles[row].reduce([] of Char) { |a, tile| a + tile.image[tile_row] }
      end
    end

    tile = Tile.new(-1, image)
    tile.print
    puts "\n\nfind mosters\n\n"

    monsters = 0
    tile.variants.each do |t|
      monsters = t.find_monsters
      break if monsters > 0
    end
    puts monsters

    puts "size: #{image.size*image.size}"
    result = image.reduce(0) { |a, row| a + row.count('#') }

    result -= monsters * MONSTER_PATTERN.size
    result
  end

  def self.build_square(square, store, row, col, ident = " ") : Bool
    output = STDOUT
    output.flush
    output.printf("checking [ %2d, %2d ] of %3d \r", row, col, store.size)
    output.flush

    n = square.size
    ns = n - 1

    return true if store.empty?
    store.keys.each do |tile_id|
      # puts "#{ident} | checking #{tile_id}"
      store[tile_id].each do |tile_variation|
        next if row > 0 && !tile_variation.lined_up_with(square[row - 1][col])
        next if col > 0 && !tile_variation.lined_left_with(square[row][col - 1])
        square[row][col] = tile_variation

        if col < ns
          next if !build_square(square, store.reject(tile_id), row, col + 1, ident + "  ")
        else
          next if !build_square(square, store.reject(tile_id), row + 1, 0, ident + "  ")
        end

        return true
      end
    end
    return false
  end

  def rotate : Tile
    n = @image.size
    rotated_image = Array(Array(Char)).new
    n.times do |row|
      rotated_image << Array(Char).new(n, '.')
    end

    ns = n - 1
    n.times do |row|
      n.times do |col|
        rotated_image[col][ns - row] = @image[row][col]
      end
    end

    Tile.new(@id, rotated_image)
  end

  def flip_horizontally : Tile
    n = @image.size
    rotated_image = Array(Array(Char)).new
    n.times do |row|
      rotated_image << Array(Char).new(n, '.')
    end

    ns = n - 1
    n.to_i32.times do |row|
      n.times do |col|
        rotated_image[ns - row][col] = @image[row][col]
      end
    end

    Tile.new(@id, rotated_image)
  end

  def flip_vertically : Tile
    n = @image.size
    rotated_image = Array(Array(Char)).new
    n.times do |row|
      rotated_image << Array(Char).new(n, '.')
    end

    ns = n - 1
    n.to_i32.times do |row|
      n.times do |col|
        rotated_image[row][ns - col] = @image[row][col]
      end
    end

    Tile.new(@id, rotated_image)
  end

  def flip_diagonal : Tile
    n = @image.size
    rotated_image = Array(Array(Char)).new
    n.times do |row|
      rotated_image << Array(Char).new(n, '.')
    end

    ns = n - 1
    n.to_i32.times do |row|
      n.times do |col|
        rotated_image[ns - row][ns - col] = @image[row][col]
      end
    end

    Tile.new(@id, rotated_image)
  end

  def lined_up_with(tile : Tile)
    Bool
    @top == tile.bottom
  end

  def lined_left_with(tile : Tile)
    Bool
    @left == tile.right
  end

  def print
    @image.each do |row|
      puts row.join
    end
  end

  def remove_borders!
    @image = @image[1..-2]
    @image.each_with_index do |tiles, row|
      @image[row] = @image[row][1..-2]
    end
  end

  def find_monsters
    result = 0
    n = @image.size
    max_row = n - 3
    max_col = n - 19
    max_row.times do |row|
      max_col.times do |col|
        found = MONSTER_PATTERN.all? do |coord|
          @image[row + coord[0]][col + coord[1]] == '#'
        end
        result += 1 if found
      end
    end

    result
  end

  def variants
    result = Array(Tile).new
    result << self
    result << self.flip_horizontally
    result << self.flip_vertically
    result << self.flip_diagonal

    rotated = self
    3.times do
      rotated = rotated.rotate
      result << rotated.flip_horizontally
      result << rotated.flip_vertically
      result << rotated.flip_diagonal
    end
    result.uniq
  end
end
