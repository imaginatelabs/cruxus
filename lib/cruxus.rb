require_relative "core/cxconf"
require_relative "core/plugin_loader"
require_relative "core/cx_workflow_plugin_base"
require_relative "core/commands/version_cmd"
require_relative "core/commands/feature_cmd"
require_relative "core/commands/latest_cmd"
require_relative "core/commands/build_cmd"
require_relative "core/commands/review_cmd"
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

    desc format(FMT, "help", "[COMMAND]"),
         "Describe available commands or one specific command"
    def help(command = nil, subcommand = false)
      super command, subcommand
    end

    desc format(FMT, "land", "[COMMIT_MESSAGE] [-rh]"),
         "Squashes and lands feature branch onto '#{CxConf.vcs.main_branch}'"
    option :remote,
           desc: "Remote server to land changes",
           aliases: "-r",
           default: CxConf.vcs.remote
    option :hold,
           desc: "Hold from pushing changes to the remote",
           aliases: "-h",
           default: CxConf.vcs.push_hold
    def land(message = nil)
      invoke :latest, [], {}
      invoke :build, [], {}
      vcs.prepare_to_land_changes message, CxConf.vcs.main_branch
      vcs.land_changes options[:remote], CxConf.vcs.main_branch
    end

    include WorkflowLoader
  end
end
