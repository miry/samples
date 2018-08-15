# frozen_string_literal: true

require 'ougai'
require 'optparse'

require_relative '../distribusion'

module Distribusion
  # Run application form command line
  class CLI
    LOG_FILE_PATH = './log/distribusion.log'
    DEFAULT_OPTIONS = {
      passphrase: '',
      log_level: Logger::INFO
    }.freeze
    SOURCES = %w[sentinels sniffers loopholes].freeze

    attr_reader :logger

    def initialize(log_level: Logger::DEBUG, passphrase:, sources: 'all')
      @logger = setup_logger(log_level)
      @passphrase = passphrase
      @logger.debug 'Options', log_level: log_level, passphrase: passphrase
      @driver = Distribusion::Driver.new(logger: @logger, passphrase: @passphrase)
      @sources = if sources == 'all'
                   SOURCES
                 else
                   sources.split ','
                 end
    end

    def run
      process_sentinels if @sources.include?('sentinels')
      process_sniffers if @sources.include?('sniffers')
      process_loopholes if @sources.include?('loopholes')
    end

    def self.run
      options = DEFAULT_OPTIONS.merge(parsed_options)
      new(options).run
    end

    # rubocop:disable Metrics/MethodLength
    def self.parsed_options
      result = {}

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: local [options]'

        opts.on('-p', '--passphrase PASSWORD', 'Password to access services') do |v|
          result[:passphrase] = v
        end

        opts.on('-s', '--sources SOURCE', 'Specific sources comma seprated. Default: all') do |v|
          result[:sources] = v
        end

        opts.on('-v', '--verbose', 'Debug') do |_v|
          result[:log_level] = Logger::DEBUG
        end
      end
      parser.parse!
      result
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument => e
      puts [e.message, parser.banner]
      exit 1
    end
    private_class_method :parsed_options
    # rubocop:enable Metrics/MethodLength

    private

    def process_sentinels
      logger.info('Process sentinels...')
      sentinels = @driver.import_sentinels
      routes = Distribusion::Route.from_sentinels sentinels
      @driver.submit routes
    end

    def process_sniffers
      logger.info('Process sniffers...')
      sniffers = @driver.import_sniffers
      routes = Distribusion::Route.from_sniffers sniffers
      @driver.submit routes
    end

    def process_loopholes
      logger.info('Process loopholes...')
      loopholes = @driver.import_loopholes
      routes = Distribusion::Route.from_loopholes loopholes
      @driver.submit routes
    end

    def setup_logger(level)
      logger = Ougai::Logger.new(STDOUT)
      logger.formatter = Ougai::Formatters::Readable.new
      logger.with_fields = { version: Distribusion::VERSION }
      logger.level = level

      file_logger = Ougai::Logger.new(LOG_FILE_PATH)
      file_logger.level = level
      logger.extend Ougai::Logger.broadcast(file_logger)
    end
  end
end
