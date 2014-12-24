require "bundler/vendored_thor"

# Base class for all workflow plugins
class CxPluginBase < Thor
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
end
