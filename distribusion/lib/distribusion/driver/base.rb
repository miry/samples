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
        logger.info("Process #{@source}...")
        submit(routes_from_data)
      end

      def self.logger=(logger = Logger.new)
        @logger = logger
      end

      def self.logger
        @logger ||= Logger.new(STDOUT)
      end

      def logger
        ::Distribusion::Driver::Base.logger
      end

      def build_routes(_data)
        []
      end

      def routes_from_data
        build_routes(parse(load))
      end

      def parse(_data)
        []
      end

      def submit(records)
        logger.info "Submit #{records.size}"
        records.each do |record|
          post record
        end
      end

      def load
        unzip download
      end

      private

      def download
        logger.debug 'Downloading', url: url
        Down.download(url, max_size: MAX_FILE_SIZE)
      end

      def unzip(archive)
        result = {}
        Zip::File.open(archive.path) do |zipfile|
          zipfile.glob('*/*.{csv,json}').each do |entry|
            name = File.basename(entry.name, '.*').to_sym
            result[name] ||= ''
            result[name] += entry.get_input_stream.read
            logger.debug "Extracting #{entry.name}", content: result[name]
          end
        end
        result
      end

      def url
        @url ||= BASE_URL + "?passphrase=#{@passphrase}&source=#{@source}"
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

      # Converts Hash to HTTP query
      def to_query(hash)
        hash.map do |k, v|
          "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
        end.join('&')
      end

      # Build http object
      def http
        @http ||= begin
          result = Net::HTTP.new(BASE_URI.host, BASE_URI.port)
          result.use_ssl = true
          result
        end
      end
    end
  end
end
