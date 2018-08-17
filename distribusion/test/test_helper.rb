# frozen_string_literal: true

require 'simplecov' # These two lines must go first
SimpleCov.minimum_coverage 91
SimpleCov.start

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'

require 'support/logger'
require 'support/fixtures'

require 'distribusion'

Distribusion::Driver::Base.logger = setup_logger
