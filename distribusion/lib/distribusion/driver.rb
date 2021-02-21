# frozen_string_literal: true

require "down"
require "zip"
require "csv"
require "json"

require "net/http"

require_relative "driver/sentinel"
require_relative "driver/sniffer"
require_relative "driver/loophole"

module Distribusion
  # Abstract class to load sources from service to local storage.
  class Driver
    def initialize(passphrase:)
      @passphrase = passphrase
    end

    def process_sentinels
      ::Distribusion::Driver::Sentinel.new(passphrase: @passphrase).process
    end

    def process_sniffers
      ::Distribusion::Driver::Sniffer.new(passphrase: @passphrase).process
    end

    def process_loopholes
      ::Distribusion::Driver::Loophole.new(passphrase: @passphrase).process
    end
  end
end
