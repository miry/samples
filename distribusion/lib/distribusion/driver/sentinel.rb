# frozen_string_literal: true

require_relative 'base'

module Distribusion
  class Driver
    # Driver to process sentinel response
    class Sentinel < Distribusion::Driver::Base
      def initialize(passphrase:)
        super source: :sentinels, passphrase: passphrase
      end

      def parse(sentinels_info)
        result = []
        CSV.parse(sentinels_info[sentinels_info.keys.first], CSV_OPTIONS) do |route|
          result << ::Distribusion::Sentinel.new(route.to_hash)
        end
        { routes: result }
      end
    end
  end
end
