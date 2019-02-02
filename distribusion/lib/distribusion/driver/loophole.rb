# frozen_string_literal: true

require_relative 'base'

module Distribusion
  class Driver
    # Driver to process loopholes response
    class Loophole < Distribusion::Driver::Base
      def initialize(passphrase:)
        super source: :loopholes, passphrase: passphrase
      end

      def parse(loophole_info)
        return { node_pairs: {}, routes: {} } if loophole_info.nil? || loophole_info.empty?

        result = {}
        loophole_info.each do |name, content|
          result[name] = JSON.parse(content, symbolize_names: true)[name]
        end
        result
      end

      def build_routes(node_pairs:, routes:)
        return [] if [node_pairs, routes].any? { |i| i.nil? || i.empty? }

        indexed_node_pairs = indexing_by(node_pairs, :id)
        combined_routes = combine_routes(indexed_node_pairs, routes)

        result = []
        combined_routes.keys.each do |route_id|
          # Expecting that records has indexes connected to smae route uniq and growing by 1
          nodes = combined_routes[route_id].sort_by(&:start_time)
          result << build_route(start_node: nodes[0], end_node: nodes[-1])
        end
        result
      end

      private

      def build_route(start_node:, end_node:)
        Distribusion::Route.new(
          source: :loopholes,
          start_node: start_node.start_node,
          end_node: end_node.end_node,
          start_time: start_node.start_time,
          end_time: end_node.end_time
        )
      end

      def combine_routes(node_pairs, routes)
        result = {}
        routes.each do |route|
          next unless node_pairs.key? route[:node_pair_id]

          node_pair = node_pairs[route[:node_pair_id]]
          result[route[:route_id]] ||= []
          attributes = route.merge(start_node: node_pair[:start_node], end_node: node_pair[:end_node])
          result[route[:route_id]] << loophole(attributes)
        end
        result
      end

      def loophole(attributes)
        attributes.delete(:route_id)
        attributes.delete(:node_pair_id)
        Distribusion::Loophole.new(attributes)
      end
    end
  end
end
