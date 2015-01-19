require "bundler/vendored_thor"
require_relative "cxconf"
require_relative "formatter"
require_relative "log_helper"

# Base class for all workflow plugins
class CxPluginBase < Thor
  def initialize(args = [], options = {}, config = {})
    super(args, options, config)
    @formatter = LogHelper.load_formatter(self.class.name, @options)
  end

  class << self
    # rubocop:disable all
    def help_desc(help_desc)
      @help_desc = help_desc
    end

    def help_text
      @help_desc
    end
    # rubocop:enable all
  end

  no_commands do
    extend Formatter
  end
end
