require_relative "core/cxconf"
require_relative "core/plugin_loader"
require_relative "core/cx_workflow_plugin_base"

module Cx
  # Entry point to the application
  class Cruxus < CxWorkflowPluginBase
    # Logging options
    class_option :log_file, desc: "File output is logged to.",
                            aliases: "-F",
                            default: false,
                            banner: "/path/to/log/file.log|(blank=cruxus.log)",
                            group: "logging"

    class_option :output_formatter, desc: "File format for log output.",
                                    aliases: "-O",
                                    default: CxConf.log.formatter,
                                    banner: CxConf.log.formatter_options.join("|"),
                                    group: "logging"

    class_option :log_level, desc: "Level at which output is displayed.",
                             aliases: "-L",
                             default: CxConf.log.level,
                             banner: CxConf.log.level_options.join("|"),
                             group: "logging"

    desc "version",
         "Prints the current version of Cruxus. (Aliases: --version, -v)"
    map "-v" => "version",
        "--version" => "version"
    long_desc "Prints the current version of Cruxus."
    def version
      inf(CxConf.version)
    end

    desc format(FMT, "help", "[COMMAND]"),
         "Describe available commands or one specific command"
    def help(command = nil, subcommand = false)
      super command, subcommand
    end

    desc format(FMT, "feature", "FEATURE_NAME [-s]"),
         "Creates a feature branch for you to develop your changes"
    option :start_commit,
           desc: "Commit you want to branch from",
           aliases: "-s",
           default: "HEAD"
    def feature(feature_name)
      vcs.start_new_feature options[:start_commit], feature_name
    end

    desc format(FMT, "latest", "[MAIN_BRANCH]"),
         "Pull changes from the main branch into current branch"
    def latest(main_branch = CxConf.vcs.main_branch)
      vcs.latest_changes main_branch
    end

    desc "build", "Run the build"
    def build
      bld.cmd CxConf.build.cmd
    end

    desc format(FMT, "review", "[-r]"), "Creates and submits a code review"
    option :remote,
           desc: "Remote server to submit code review",
           aliases: "-r",
           default: CxConf.vcs_code_review.remote
    def review
      invoke :latest
      invoke :build
      vcs.submit_code_review options[:remote]
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

    PluginLoader.find_plugin_files("workflow").each do |plugin_file|
      require plugin_file.absolute_path
      # rubocop:disable all
      eval("extend #{plugin_file.plugin_name}")
      eval("desc format(FMT, '#{plugin_file.instance_name.downcase}','[COMMAND] [ARGS]'), '#{eval("#{plugin_file.module_class_name}.help_text")}'")
      eval("subcommand '#{plugin_file.instance_name.downcase}', #{plugin_file.module_class_name}")
      # rubocop:enable all
    end
  end
end
