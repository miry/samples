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

    attr_reader :logger

    def initialize(log_level: Logger::DEBUG, passphrase:)
      @logger = setup_logger(log_level)
      @passphrase = passphrase
      @logger.debug 'Options', log_level: log_level, passphrase: passphrase
    end

    def run
      logger.info('Loading sentinels...')
      Distribusion::Importer.new(logger: @logger, passphrase: @passphrase, source: :sentinels).import
    end

    def self.run
      new(options).run
    end

    def self.options
      result = {}

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: local [options]'

        opts.on('-p', '--passphrase PASSWORD', 'Password to access services') do |v|
          result[:passphrase] = v
        end

        opts.on('-v', '--verbose', 'Debug') do |_v|
          result[:log_level] = Logger::DEBUG
        end
      end
      parser.parse!
      DEFAULT_OPTIONS.merge(result)
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument => e
      puts e.message
      puts parser.banner
      exit 1
    end

    private

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
