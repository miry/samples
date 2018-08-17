# frozen_string_literal: true

module Distribusion
  class Driver
    # Abstract class to load sources from service to local storage.
    class Base
      def initialize(passphrase:, source:)
        @passphrase = passphrase
        @source = source
      end

      def process
        submit(build_routes(parse(load(@source))))
      end

      def self.logger=(logger = Logger.new)
        @logger = logger
      end

      def self.logger
        @logger ||= Logger.new(STDOUT)
      end

      def logger
        self.class.logger
      end

      def build_routes(_data)
        []
      end

      def load(_source)
        {}
      end

      def parse(_data)
        []
      end

      def submit(_routes)
        []
      end
    end
  end
end
