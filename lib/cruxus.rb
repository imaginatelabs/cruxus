require_relative "core/cxconf"
require_relative "core/plugin_loader"
require_relative "core/cx_workflow_plugin_base"
require_relative "core/commands/version_cmd"
require_relative "core/commands/feature_cmd"
require_relative "core/commands/latest_cmd"
require_relative "core/commands/build_cmd"
require_relative "core/commands/review_cmd"
require_relative "core/commands/land_cmd"
require_relative "core/workflow_loader"
require_relative "core/logging_options"

module Cx
  # Entry point to the application
  class Cruxus < CxWorkflowPluginBase
    include LoggingOptions
    include VersionCmd
    include FeatureCmd
    include LatestCmd
    include BuildCmd
    include ReviewCmd
    include LandCmd
    include WorkflowLoader

    desc format(FMT, "help", "[COMMAND]"),
         "Describe available commands or one specific command"
    def help(command = nil, subcommand = false)
      super command, subcommand
    end
  end
end
