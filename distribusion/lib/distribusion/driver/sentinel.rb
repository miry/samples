# frozen_string_literal: true

require_relative "base"

module Distribusion
  class Driver
    # Driver to process sentinel response
    class Sentinel < Distribusion::Driver::Base
      def initialize(passphrase:)
        super source: :sentinels, passphrase: passphrase
      end

      def parse(sentinels_info)
        data = []
        return {routes: data} if sentinels_info.nil? || sentinels_info.empty?

        CSV.parse(sentinels_info[sentinels_info.keys.first], **CSV_OPTIONS) do |route|
          data << ::Distribusion::Sentinel.new(**route.to_hash)
        end
        {routes: data}
      end

      def build_routes(routes:)
        result = []
        return result if routes.nil? || routes.empty?

        combined_routes = routes_by_id(routes)
        combined_routes.keys.each do |route_id|
          # Expecting that records has indexes connected to smae route uniq and growing by 1
          nodes = combined_routes[route_id].sort_by(&:index)
          next if nodes.size == 1

          result << build_route(nodes[0], nodes[-1])
        end
        result
      end

      private

      def routes_by_id(routes)
        result = {}
        routes.each do |sentinel|
          result[sentinel.route_id] ||= []
          result[sentinel.route_id] << sentinel
        end
        result
      end

      def build_route(start_node, end_node)
        Distribusion::Route.new(
          source: :sentinels,
          start_node: start_node.node,
          end_node: end_node.node,
          start_time: start_node.time,
          end_time: end_node.time
        )
      end
    end
  end
end
