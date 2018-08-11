# frozen_string_literal: true

require 'down'

module Distribusion
  # Abstract class to load sources from service to local storage.
  class Importer
    BASE_URL = 'https://challenge.distribusion.com/the_one/routes'
    MAX_FILE_SIZE = 5 * 1024 * 1024

    attr_reader :logger

    def initialize(source:, passphrase:, logger:)
      @source = source
      @passphrase = passphrase
      @logger = logger
    end

    def import
      download
    end

    private

    def download
      logger.debug 'Downloading', url: url
      result = Down.download(url, max_size: MAX_FILE_SIZE)
      logger.debug 'Downloaded success', result.content_type

      result
    end

    def url
      BASE_URL + "?passphrase=#{@passphrase}&source=#{@source}"
    end
  end
end
