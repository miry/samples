# frozen_string_literal: true

# :nodoc:
module Distribusion
  # :nodoc:
  class Route
    attr_accessor :start_node, :end_node, :start_time, :end_time

    def initialize(source:, start_node:, end_node:, start_time:, end_time:)
      @start_node = start_node
      @end_node = end_node
      @start_time = start_time
      @end_time = end_time
      @source = source
    end

    def to_hash
      {
        source: @source,
        start_node: @start_node,
        end_node: @end_node,
        start_time: @start_time,
        end_time: @end_time
      }
    end
  end
end
