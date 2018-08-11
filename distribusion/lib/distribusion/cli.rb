# frozen_string_literal: true

require 'ougai'
require_relative '../distribusion'

class Distribusion
  # Run application form command line
  class CLI
    LOG_FILE_PATH = './log/distribusion.log'

    attr_reader :logger

    def initialize(log_level: Logger::DEBUG)
      @logger = setup_logger(log_level)
    end

    def run
      logger.info('Hello!')
      logger.error('Failed to do something.')
      logger.warn('Ignored something.')
    end

    private

    def setup_logger(level)
      logger = Ougai::Logger.new(STDOUT)
      logger.formatter = Ougai::Formatters::Readable.new
      logger.with_fields = { version: '0.0.1' }
      logger.level = level

      error_logger = Ougai::Logger.new(LOG_FILE_PATH)
      error_logger.level = level
      logger.extend Ougai::Logger.broadcast(error_logger)
    end
  end
end
