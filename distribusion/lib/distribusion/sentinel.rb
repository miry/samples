# frozen_string_literal: true

# :nodoc:
class Distribusion
  # :nodoc:
  class Sentinel
    attr_accessor :route_id, :node, :index, :time

    def initialize(route_id:, node:, index:, time:)
      @route_id = route_id
      @node = node
      @index = index
      @time = time
    end
  end
end
