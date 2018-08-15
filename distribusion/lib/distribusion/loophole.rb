# frozen_string_literal: true

# :nodoc:
module Distribusion
  # :nodoc:
  class Loophole
    attr_accessor :start_node, :end_node, :route_id, :node_pair_id, :start_time, :end_time
    def initialize(start_node:,end_node:, route_id:, node_pair_id:, start_time:, end_time:)
      @start_node = start_node
      @end_node = end_node
      @start_time = start_time[0...-1]
      @end_time = end_time[0...-1]
    end
  end
end
