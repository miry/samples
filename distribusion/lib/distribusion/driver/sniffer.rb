# frozen_string_literal: true

require_relative "base"

module Distribusion
  class Driver
    # Driver to process sniffers response
    class Sniffer < Distribusion::Driver::Base
      def initialize(passphrase:)
        super source: :sniffers, passphrase: passphrase
      end

      def parse(sniffer_info)
        return {node_times: {}, routes: {}, sequences: {}} if sniffer_info.nil? || sniffer_info.empty?

        result = {}
        sniffer_info.each do |name, content|
          result[name] = []
          CSV.parse(content, **CSV_OPTIONS) do |row|
            result[name] << row.to_hash
          end
        end
        result
      end

      def build_routes(node_times:, routes:, sequences:)
        return [] if [node_times, routes, sequences].any? { |i| i.nil? || i.empty? }

        indexed_node_times = indexing_by(node_times, :node_time_id)
        indexed_routes = indexing_by(routes, :route_id)
        combined_routes = combine_routes(indexed_node_times, indexed_routes, sequences)

        result = []
        combined_routes.values.each do |nodes|
          # Expecting that records has indexes connected to smae route uniq and growing by 1
          duration = nodes.map(&:duration).reduce(:+)
          result << build_route(start_node: nodes[0], end_node: nodes[-1], duration: duration)
        end
        result
      end

      private

      def build_route(start_node:, end_node:, duration:)
        Distribusion::Route.new(
          source: :sniffers,
          start_node: start_node.start_node,
          end_node: end_node.end_node,
          start_time: start_node.time.utc.iso8601[0...-1],
          end_time: (start_node.time + duration).iso8601[0...-1]
        )
      end

      def combine_routes(node_times, routes, sequences)
        result = {}
        sequences.each do |sequence|
          next if !routes.key?(sequence[:route_id]) || !node_times.key?(sequence[:node_time_id])

          result[sequence[:route_id]] ||= []
          attributes = routes[sequence[:route_id]].merge(node_times[sequence[:node_time_id]])
          attributes.delete(:route_id)
          attributes.delete(:node_time_id)
          result[sequence[:route_id]] << Distribusion::Sniffer.new(**attributes)
        end
        result
      end
    end
  end
end
