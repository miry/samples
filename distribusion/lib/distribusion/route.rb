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

    # rubocop:disable Metrics/MethodLength
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
      indexed_node_pairs = {}
      node_pairs.each do |node_pair|
        indexed_node_pairs[node_pair[:id]] = node_pair
      end

      combined_routes = {}
      routes.each do |route|
        next unless indexed_node_pairs.key? route[:node_pair_id]
        node_pair = indexed_node_pairs[route[:node_pair_id]]
        combined_routes[route[:route_id]] ||= []
        attributes = route.merge({start_node: node_pair[:start_node], end_node: node_pair[:end_node]})

        combined_routes[route[:route_id]] << Distribusion::Loophole.new( attributes )
      end

      result = []
      combined_routes.keys.each do |route_id|
        # Expecting that records has indexes connected to smae route uniq and growing by 1
        nodes = combined_routes[route_id].sort_by(&:start_time)
        start_node = nodes[0]
        end_node = nodes[-1]
        result << new(
          source: :loopholes,
          start_node: start_node.start_node,
          end_node: end_node.end_node,
          start_time: start_node.start_time,
          end_time: end_node.end_time
        )
      end
      result
    end

    def self.logger=(logger = Logger.new)
      @logger = logger
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
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
