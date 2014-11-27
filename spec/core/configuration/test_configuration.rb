require 'minitest/autorun'
require './lib/core/configuration_loader'

class TestConfiguration < MiniTest::Unit::TestCase
  include ConfigurationLoader
  def test_multiple_configuration_files_should_override_configuration_based_on_file_load_order
    config = load_config_files(
      [
        'spec/core/configuration/.cxconf1',
        'spec/core/configuration/.cxconf2'
      ]
    )
    assert_equal('my value override', config.my_value_override)
    assert_equal('my value no override', config.my_value_no_override)
  end

end