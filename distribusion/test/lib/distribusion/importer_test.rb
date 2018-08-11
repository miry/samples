# frozen_string_literal: true

require 'test_helper'

class ImporterTest < Minitest::Test
  def setup
    @importer = Distribusion::Importer.new(source: 'foo', passphrase: 'test', logger: setup_logger)
  end

  def test_importer_has_method_import
    assert_includes @importer.methods, :import
  end
end
