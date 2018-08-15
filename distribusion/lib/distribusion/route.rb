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

    # rubocop:disable Metrics/MethodLength Metrics/AbcSize
    def self.from_sentinels(routes:)
      combined_routes = {}
      routes.each do |sentinel|
        combined_routes[sentinel.route_id] ||= []
        combined_routes[sentinel.route_id] << sentinel
      end

      result = []
      combined_routes.keys.each do |route_id|
        # Expecting that records has indexes connected to smae route uniq and growing by 1
        nodes = combined_routes[route_id].sort_by(&:index)
        next if nodes.size == 1
        start_node = nodes[0]
        end_node = nodes[-1]
        result << new(
          source: :sentinels,
          start_node: start_node.node,
          end_node: end_node.node,
          start_time: start_node.time,
          end_time: end_node.time
        )
      end
      result
    end
    # rubocop:enable Metrics/MethodLength

    def self.from_sniffers(node_times:, routes:, sequences:)
      logger.debug 'Need to implement', node_times: node_times, routes: routes, sequences: sequences
      []
    end

    def self.from_loopholes(node_pairs:, routes:)
      logger.debug 'Need to implement', node_pairs: node_pairs, routes: routes
      []
    end

    def self.logger=(logger=Logger.new)
      @logger = logger
    end

    def self.logger
      @logger
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
