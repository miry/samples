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

    # rubocop:disable Metrics/MethodLength
    def self.from_sniffers(node_times:, routes:, sequences:)
      indexed_node_times = {}
      node_times.each do |node_time|
        indexed_node_times[node_time[:node_time_id]] = node_time
      end

      indexed_routes = {}
      routes.each do |route|
        indexed_routes[route[:route_id]] = route
      end

      combined_routes = {}
      sequences.each do |sequence|
        next unless indexed_routes.key? sequence[:route_id]
        next unless indexed_node_times.key? sequence[:node_time_id]

        combined_routes[sequence[:route_id]] ||= []
        attributes = indexed_routes[sequence[:route_id]].merge(indexed_node_times[sequence[:node_time_id]])
        attributes.delete(:route_id)
        attributes.delete(:node_time_id)
        combined_routes[sequence[:route_id]] << Distribusion::Sniffer.new(attributes)
      end

      result = []
      combined_routes.values.each do |nodes|
        # Expecting that records has indexes connected to smae route uniq and growing by 1
        start_node = nodes[0]
        end_node = nodes[-1]
        duration = nodes.map(&:duration).reduce(:+)
        result << new(
          source: :sniffers,
          start_node: start_node.start_node,
          end_node: end_node.end_node,
          start_time: start_node.time.utc.iso8601[0...-1],
          end_time: (start_node.time + duration).iso8601[0...-1]
        )
      end
      result
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
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
        attributes = route.merge(start_node: node_pair[:start_node], end_node: node_pair[:end_node])
        attributes.delete(:route_id)
        attributes.delete(:node_pair_id)
        combined_routes[route[:route_id]] << Distribusion::Loophole.new(attributes)
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
    # rubocop:enable Metrics/MethodLength

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
