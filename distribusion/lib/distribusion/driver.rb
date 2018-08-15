# frozen_string_literal: true

require 'down'
require 'zip'
require 'csv'
require 'net/http'

module Distribusion
  # Abstract class to load sources from service to local storage.
  class Driver
    BASE_URL = 'https://challenge.distribusion.com/the_one/routes'
    BASE_URI = URI.parse(BASE_URL)

    MAX_FILE_SIZE = 5 * 1024 * 1024
    TMP_FOLDER = 'tmp/importer/'
    CSV_OPTIONS = {
      encoding: 'bom|utf-8',
      col_sep: ', ',
      row_sep: "\n",
      quote_char: '"',
      headers: :first_row,
      header_converters: :symbol
    }.freeze

    attr_reader :logger

    def initialize(passphrase:, logger:)
      @passphrase = passphrase
      @logger = logger
    end

    def import_sentinels
      sentinels_routes = load(:sentinels)
      result = []
      CSV.parse(sentinels_routes[sentinels_routes.keys.first], CSV_OPTIONS) do |route|
        result << Sentinel.new(route.to_hash)
      end
      result
    end

    def import_sniffers
      load(:sniffers)
      []
    end

    def import_loopholes
      []
    end

    def submit(records)
      records.each do |record|
        post record
      end
    end

    private

    def load(source)
      unzip download(source)
    end

    def download(source)
      logger.debug 'Downloading', url: url(source)
      result = Down.download(url(source), max_size: MAX_FILE_SIZE)
      logger.debug 'Downloaded success', result.content_type
      result
    end

    def unzip(archive)
      logger.debug "Unpacking #{archive.path}"
      result = {}
      Zip::File.open(archive.path) do |zipfile|
        zipfile.glob('*/*.csv').each do |entry|
          logger.debug "Extracting #{entry.name}"
          result[entry.name] ||= ''
          result[entry.name] += entry.get_input_stream.read
          logger.debug result[entry.name]
        end
      end
      result
    end

    def url(source)
      BASE_URL + "?passphrase=#{@passphrase}&source=#{source}"
    end

    # Submit route to service
    def post(record)
      request = Net::HTTP::Post.new(BASE_URI.request_uri)
      request.body = to_query record.to_hash.merge(passphrase: @passphrase)

      response = http.request(request)
      return if response.code == '201'

      logger.debug 'Not valid request',
                   response: { code: response.code, body: response.body },
                   request: request.body,
                   record: record
    end

    # Build http object
    def http
      @http ||= begin
        result = Net::HTTP.new(BASE_URI.host, BASE_URI.port)
        result.use_ssl = true
        result
      end
    end

    def to_query(hash)
      hash.map do |k, v|
        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
      end.join('&')
    end
  end
end
