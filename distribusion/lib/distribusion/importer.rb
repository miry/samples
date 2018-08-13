# frozen_string_literal: true

require 'down'
require 'zip'
require 'csv'

module Distribusion
  # Abstract class to load sources from service to local storage.
  class Importer
    BASE_URL = 'https://challenge.distribusion.com/the_one/routes'
    MAX_FILE_SIZE = 5 * 1024 * 1024
    TMP_FOLDER = 'tmp/importer/'
    CSV_OPTIONS = {
      encoding: 'bom|utf-8',
      col_sep: ', ',
      row_sep: "\n",
      quote_char: '"',
      headers: :first_row,
      header_converters: :symbol,
    }.freeze

    attr_reader :logger

    def initialize(source:, passphrase:, logger:)
      @source = source
      @passphrase = passphrase
      @logger = logger
    end

    def import
      sentinels_routes = load
      result = []
      CSV.parse(sentinels_routes, CSV_OPTIONS) do |route|
        result << Sentinel.new(route.to_hash)
      end
      result
    end

    private

    def load
      unzip download
    end

    def download
      logger.debug 'Downloading', url: url
      result = Down.download(url, max_size: MAX_FILE_SIZE)
      logger.debug 'Downloaded success', result.content_type
      result
    end

    def unzip(archive)
      logger.debug "Unpack #{archive.path}"
      result = ''
      Zip::File.open(archive.path) do |zipfile|
        zipfile.glob('*/*.csv').each do |entry|
          logger.debug "Extracting #{entry.name}"
          result += entry.get_input_stream.read
          logger.debug result
        end
      end
      result
    end

    def url
      BASE_URL + "?passphrase=#{@passphrase}&source=#{@source}"
    end
  end
end
