require "thor"
require_relative "cxconf"
require_relative "formatter"
require_relative "log_helper"

# Base class for all workflow plugins
class CxWorkflowPluginBase < Thor
  FMT = "%-8s %s"

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
    def vcs
      @vcs ||= PluginLoader.load_plugin CxConf.vcs.action, "vcs_actions",
                                        @formatter, options, CxConf
    end

    def bld
      @build ||= PluginLoader.load_plugin CxConf.build.action, "build_actions",
                                          @formatter, options, CxConf
    end
  end
end
