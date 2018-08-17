# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'

require 'support/logger'
require 'support/fixtures'

require 'distribusion'

logger = setup_logger
Distribusion::Driver::Base.logger = logger
Distribusion::Route.logger = logger
