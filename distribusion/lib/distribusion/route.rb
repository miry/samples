# frozen_string_literal: true

# :nodoc:
module Distribusion
  # :nodoc:
  class Route
    attr_accessor :start_node, :end_node, :start_time, :end_time

    def initialize(start_node:, end_node:, start_time:, end_time:)
      @start_node = start_node
      @end_node = end_node
      @start_time = start_time
      @end_time = end_time
    end

    # rubocop:disable Metrics/MethodLength Metrics/AbcSize
    # rubocop:disable Metrics/AbcSize
    def self.from_sentinels(sentinels)
      routes = {}
      sentinels.each do |sentinel|
        routes[sentinel.route_id] ||= []
        routes[sentinel.route_id] << sentinel
      end

      result = []
      routes.keys.each do |route_id|
        # Expecting that records has indexes connected to smae route uniq and growing by 1
        nodes = routes[route_id].sort_by(&:index)
        start_node = nodes[0]
        end_node = nodes[-1]
        result << new(
          start_node: start_node.node,
          end_node: end_node.node,
          start_time: start_node.time,
          end_time: end_node.time
        )
      end
      result
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end
end
