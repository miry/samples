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
      @time = Time.parse(time).utc.iso8601
    end
  end
end
