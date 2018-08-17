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
        data = []
        return { routes: data } if sentinels_info.nil? || sentinels_info.empty?

        CSV.parse(sentinels_info[sentinels_info.keys.first], CSV_OPTIONS) do |route|
          data << ::Distribusion::Sentinel.new(route.to_hash)
        end
        { routes: data }
      end
    end
  end
end
