# frozen_string_literal: true

require "ougai"

def setup_logger(level: Logger::ERROR, logpath: "./log/test.log")
  logger = Ougai::Logger.new($stdout)
  logger.formatter = Ougai::Formatters::Readable.new
  logger.level = level

  file_logger = Ougai::Logger.new(logpath)
  file_logger.level = level
  logger.extend Ougai::Logger.broadcast(file_logger)
end
