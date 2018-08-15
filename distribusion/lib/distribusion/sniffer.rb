# frozen_string_literal: true

# :nodoc:
module Distribusion
  # :nodoc:
  class Sniffer
    attr_accessor :start_node, :end_node, :time, :duration
    def initialize(start_node:, end_node:, time:, time_zone:, duration_in_milliseconds:)
      @start_node = start_node
      @end_node = end_node
      @time = Time.parse time + time_zone
      @duration = duration_in_milliseconds.to_i / 1000
    end
  end
end
