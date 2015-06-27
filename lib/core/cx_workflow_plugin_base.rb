require "thor"
require_relative "cxconf"
require_relative "logging_wrapper"
require_relative "helpers/log_helper"

# Base class for all workflow plugins
class CxWorkflowPluginBase < Thor
  def initialize(args = [], options = {}, config = {})
    super(args, options, config)
    @logger = LogHelper.load_logger(self.class.name, @options)
  end

  DESCF_FORMAT = "%-8s %s"
  DESC_HELP = format(DESCF_FORMAT, "help", "[COMMAND]")

  # Overrides the existing thor command help to improve formatting.
  desc DESC_HELP,
       "Describe available commands or one specific command"
  def help(command = nil, subcommand = false)
    super command, subcommand
  end

  class << self
    # rubocop:disable all
    def help_desc(help_desc)
      @help_desc = help_desc
    end

    def help_text
      @help_desc
    end

    # Improves formatting for desc so that args are lain out nicely
    def descf(usage, args, description, options = {})
      desc(format(DESCF_FORMAT, usage, args), description, options)
    end

    # Overrides the existing thor subcommand_help to improve formatting.
    def subcommand_help(cmd)
      desc DESC_HELP, "Describe subcommands or one specific subcommand"
      class_eval "def help(command = nil, subcommand = true); super; end"
    end
    # rubocop:enable all
  end

  no_commands do
    extend LoggingWrapper
    def vcs
      @vcs ||= PluginLoader.load_plugin CxConf.vcs.action, "vcs_actions",
                                        @logger, options, CxConf
    end

    def bld
      @build ||= PluginLoader.load_plugin CxConf.build.action, "build_actions",
                                          @logger, options, CxConf
    end
  end
end
