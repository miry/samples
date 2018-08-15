# frozen_string_literal: true

# :nodoc:
module Distribusion
  # :nodoc:
  class Sentinel
    attr_accessor :route_id, :node, :index, :time

    def initialize(route_id:, node:, index:, time:)
      @route_id = route_id.to_i
      @node = node
      @index = index.to_i
      # Not valid iso https://en.wikipedia.org/wiki/ISO_8601
      @time = Time.parse(time).utc.iso8601[0...-1]
    end
  end
end
