# https://adventofcode.com/2020/day/21

# --- Day 21: Allergen Assessment ---

# You reach the train's last stop and the closest you can get to your vacation island without getting wet. There aren't even any boats here, but nothing can stop you now: you build a raft. You just need a few days' worth of food for your journey.

# You don't speak the local language, so you can't read any ingredients lists. However, sometimes, allergens are listed in a language you do understand. You should be able to use this information to determine which ingredient contains which allergen and work out which foods are safe to take with you on your trip.

# You start by compiling a list of foods (your puzzle input), one food per line. Each line includes that food's ingredients list followed by some or all of the allergens the food contains.

# Each allergen is found in exactly one ingredient. Each ingredient contains zero or one allergen. Allergens aren't always marked; when they're listed (as in (contains nuts, shellfish) after an ingredients list), the ingredient that contains each listed allergen will be somewhere in the corresponding ingredients list. However, even if an allergen isn't listed, the ingredient that contains that allergen could still be present: maybe they forgot to label it, or maybe it was labeled in a language you don't know.

# For example, consider the following list of foods:

# mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
# trh fvjkl sbzzf mxmxvkd (contains dairy)
# sqjhc fvjkl (contains soy)
# sqjhc mxmxvkd sbzzf (contains fish)

# The first food in the list has four ingredients (written in a language you don't understand): mxmxvkd, kfcds, sqjhc, and nhms. While the food might contain other allergens, a few allergens the food definitely contains are listed afterward: dairy and fish.

# The first step is to determine which ingredients can't possibly contain any of the allergens in any food in your list. In the above example, none of the ingredients kfcds, nhms, sbzzf, or trh can contain an allergen. Counting the number of times any of these ingredients appear in any ingredients list produces 5: they all appear once each except sbzzf, which appears twice.

# Determine which ingredients cannot possibly contain any of the allergens in your list. How many times do any of those ingredients appear?

# Your puzzle answer was 2380.
# --- Part Two ---

# Now that you've isolated the inert ingredients, you should have enough information to figure out which ingredient contains which allergen.

# In the above example:

#     mxmxvkd contains dairy.
#     sqjhc contains fish.
#     fvjkl contains soy.

# Arrange the ingredients alphabetically by their allergen and separate them by commas to produce your canonical dangerous ingredient list. (There should not be any spaces in your canonical dangerous ingredient list.) In the above example, this would be mxmxvkd,sqjhc,fvjkl.

# Time to stock your raft with supplies. What is your canonical dangerous ingredient list?

# Your puzzle answer was ktpbgdn,pnpfjb,ndfb,rdhljms,xzfj,bfgcms,fkcmf,hdqkqhh.

struct AllergenFood
  property ingredients : Array(String)
  property allergens : Array(String)

  def initialize(@ingredients, @allergens)
  end

  def valid?(ingredient_to_allergen : Hash(String, String))
    test_allergens = Set.new @allergens.dup
    @ingredients.each do |ingredient|
      if ingredient_to_allergen.has_key?(ingredient)
        al = ingredient_to_allergen[ingredient]
        if test_allergens.includes?(al)
          test_allergens.delete(al)
        end
      end
    end
    test_allergens.size == 0
  end
end

class AllergenDetector
  property foods : Array(AllergenFood)
  property ingredients : Hash(String, Array(Int32))
  property ingredient_to_allergens : Hash(String, Array(String))

  def initialize(@foods)
    @ingredients = Hash(String, Array(Int32)).new
    @ingredient_to_allergens = Hash(String, Array(String)).new

    allergen_to_foods = Hash(String, Array(Array(String))).new
    @foods.each_with_index do |allergen_food, i|
      allergen_food.allergens.each do |allergen|
        allergen_to_foods[allergen] = Array(Array(String)).new if !allergen_to_foods.has_key?(allergen)
        allergen_to_foods[allergen] << allergen_food.ingredients
      end

      allergen_food.ingredients.each do |ingredient|
        @ingredients[ingredient] = Array(Int32).new if !@ingredients.has_key?(ingredient)
        @ingredients[ingredient] << i
        @ingredient_to_allergens[ingredient] = [] of String if !@ingredient_to_allergens.has_key?(ingredient)
        @ingredient_to_allergens[ingredient] += allergen_food.allergens
      end
    end

    allergen_to_ingredients = Hash(String, Array(String)).new
    allergen_to_foods.keys.each do |allergen|
      r = allergen_to_foods[allergen].reduce(allergen_to_foods[allergen][0]) { |a, i| a & i }
      allergen_to_ingredients[allergen] = r
    end

    @ingredient_to_allergens.keys.each do |ingredient|
      @ingredient_to_allergens[ingredient] = sort_by_words_count(@ingredient_to_allergens[ingredient]).select do |allergen|
        allergen_to_ingredients[allergen].includes?(ingredient)
      end
      @ingredient_to_allergens[ingredient] << "NO"
    end
  end

  def sort_by_words_count(arr)
    memo = Hash(String, Int32).new
    arr.each do |word|
      memo[word] = 0 if !memo.has_key?(word)
      memo[word] += 1
    end
    memo.keys.sort { |a, b| memo[a] <=> memo[b] }.reverse
  end

  def self.parse(list) : self
    parsed_list = [] of AllergenFood
    list.each do |food|
      next if food == ""
      items_list, allergens_list = food.split(" (contains ")
      foods = items_list.split(" ")
      allergens = allergens_list[..-2].split(", ")
      parsed_list << AllergenFood.new(foods, allergens)
    end
    self.new(parsed_list)
  end

  def ingredients_allergen
    permutation(Hash(String, String).new, @ingredients.keys)
  end

  def ingredients_without_allergens
    no_allergen = [] of String

    r = ingredients_allergen
    if !r.nil?
      no_allergen = r.keys.select { |ingredient| r[ingredient] == "NO" }
    end
    no_allergen.reduce(0) { |a, ingredient| a + @ingredients[ingredient].size }
  end

  def ingredients_list
    r = ingredients_allergen
    if !r.nil?
      r.delete_if { |ingredient, allergen| allergen == "NO" }
      ir = r.invert
      ir.keys.sort.map { |k| ir[k] }.join(",")
    else
      ""
    end
  end

  def permutation(selected_ingredients, left_ingredients)
    if left_ingredients.size == 0
      all_food_valid = @foods.all? do |allergen_food|
        allergen_food.valid?(selected_ingredients)
      end
      if all_food_valid
        return selected_ingredients
      else
        return nil
      end
    end

    left_ingredients.each do |ingredient|
      other_ingredients = left_ingredients - [ingredient]
      @ingredient_to_allergens[ingredient].each do |allergen|
        next if allergen != "NO" && selected_ingredients.values.includes?(allergen)

        selected_ingredients[ingredient] = allergen
        r = permutation(selected_ingredients, other_ingredients)
        return r if !r.nil?
      end
    end

    nil
  end
end
