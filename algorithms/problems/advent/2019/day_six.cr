# https://adventofcode.com/2019/day/6
#
# --- Day 6: Universal Orbit Map ---
#
# You've landed at the Universal Orbit Map facility on Mercury. Because navigation in space often involves transferring between orbits, the orbit maps here are useful for finding efficient routes between, for example, you and Santa. You download a map of the local orbits (your puzzle input).
#
# Except for the universal Center of Mass (COM), every object in space is in orbit around exactly one other object. An orbit looks roughly like this:
#
#                   \
#                    \
#                     |
#                     |
# AAA--> o            o <--BBB
#                     |
#                     |
#                    /
#                   /
#
# In this diagram, the object BBB is in orbit around AAA. The path that BBB takes around AAA (drawn with lines) is only partly shown. In the map data, this orbital relationship is written AAA)BBB, which means "BBB is in orbit around AAA".
#
# Before you use your map data to plot a course, you need to make sure it wasn't corrupted during the download. To verify maps, the Universal Orbit Map facility uses orbit count checksums - the total number of direct orbits (like the one shown above) and indirect orbits.
#
# Whenever A orbits B and B orbits C, then A indirectly orbits C. This chain can be any number of objects long: if A orbits B, B orbits C, and C orbits D, then A indirectly orbits D.
#
# For example, suppose you have the following map:
#
# COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L
#
# Visually, the above map of orbits looks like this:
#
#         G - H       J - K - L
#        /           /
# COM - B - C - D - E - F
#                \
#                 I
#
# In this visual representation, when two objects are connected by a line, the one on the right directly orbits the one on the left.
#
# Here, we can count the total number of orbits as follows:
#
#     D directly orbits C and indirectly orbits B and COM, a total of 3 orbits.
#     L directly orbits K and indirectly orbits J, E, D, C, B, and COM, a total of 7 orbits.
#     COM orbits nothing.
#
# The total number of direct and indirect orbits in this example is 42.
#
# What is the total number of direct and indirect orbits in your map data?
#

require "logger"

class Orbit
  property object : String
  property orbits_count : Int32
  property orbit : Orbit?

  def initialize(@object : String, @orbit : Orbit?, @orbits_count : Int32)
    puts "Init orbit with #{@orbit} -> #{@object}"
  end

  def orbits
    return 0 if @orbit.nil?
    @orbit.not_nil!.orbits + 1
  end

  def print
    parent_orbit = "NIL"
    parent_orbit = @orbit.not_nil!.print unless @orbit.nil?
    "Orbit { #{@object} } <- { #{parent_orbit} } [#{@orbits_count}] "
  end
end

class OrbitsMap
  @logger : Logger

  def initialize(input : Array(String))
    @orbits = {} of String => Orbit
    @leaves = {} of String => Bool
    @logger = logger
    parse_dag(input)
  end

  def orbits(object : String? = nil)
    return 0 unless @orbits.has_key?(object)
    @orbits[object].orbits_count
  end

  def all_orbits
    @logger.debug("-> all_orbits")
    result = 0
    @orbits.each_value do |orbit|
      # @logger.debug("---> leave: #{orbit.object} #{orbit.orbits_count}")

      result += orbit.orbits
    end
    result
  end

  def parse_dag(input : Array(String))
    @logger.debug("-> parse_dag")
    input.each do |rule|
      @logger.debug("---> rule: #{rule}")
      object, orbit = rule.split(")")

      unless @orbits.has_key?(object)
        @orbits[object] = Orbit.new(object, nil, 0)
      end

      unless @orbits.has_key?(orbit)
        @orbits[orbit] = Orbit.new(orbit, nil, 0)
      end

      raise "found double direct orbits" unless @orbits[orbit].orbit.nil?

      @orbits[orbit].orbit = @orbits[object]
      @orbits[orbit].orbits_count = @orbits[object].orbits + 1
      @logger.debug("---> #{@orbits[orbit].print}")

      @leaves[orbit] = true unless @leaves.has_key?(orbit)
      @leaves.delete(object) if @leaves.has_key?(object)
    end

    @logger.debug("---> leaves: #{@leaves}")
  end

  def logger
    log = Logger.new(STDERR)
    log.level = Logger::DEBUG
    return log
  end
end
