require_relative "core/cxconf"
require_relative "core/plugin_loader"
require_relative "core/cx_workflow_plugin_base"

module Cx
  # Entry point to the application
  class Cruxus < CxWorkflowPluginBase
    # Logging options
    class_option :log_file, desc: "File output is logged to.",
                            aliases: :f,
                            default: false,
                            banner: "/path/to/log/file.log|(blank=cruxus.log)",
                            group: "logging"

    class_option :output_formatter, desc: "File format for log output.",
                                    aliases: :o,
                                    default: CxConf.log.formatter,
                                    banner: CxConf.log.formatter_options.join("|"),
                                    group: "logging"

    class_option :log_level, desc: "Level at which output is displayed.",
                             aliases: :l,
                             default: CxConf.log.level,
                             banner: CxConf.log.level_options.join("|"),
                             group: "logging"

    desc "version", "Prints the current version of Cruxus"
    def version
      inf(CxConf.version)
    end

    desc "feature", "Creates a feature branch for you to develop your changes"
    option :start_commit,
           desc: "Commit you want to branch from",
           default: "HEAD"
    def feature(feature_name)
      vcs.start_new_feature options[:start_commit], feature_name
    end

    desc "latest", "Pull changes from the main branch into current branch"
    def latest(main_branch = CxConf.vcs.main_branch)
      vcs.latest_changes main_branch
    end

    desc "build", "Run the build"
    def build
      bld.cmd CxConf.build.cmd
    end

    desc "review", "Creates and submits a code review"
    option :remote,
           desc: "Remote server to submit code review",
           default: CxConf.vcs_code_review.remote
    def review
      invoke :latest
      invoke :build
      vcs.submit_code_review options[:remote]
    end

    PluginLoader.find_plugin_files("workflow").each do |plugin_file|
      require plugin_file.absolute_path
      # rubocop:disable all
      eval("extend #{plugin_file.plugin_name}")
      eval("desc '#{plugin_file.instance_name.downcase} [COMMAND] [ARGS]', '#{eval("#{plugin_file.module_class_name}.help_text")}'")
      eval("subcommand '#{plugin_file.instance_name.downcase}', #{plugin_file.module_class_name}")
      # rubocop:enable all
    end

    no_commands do
      def vcs
        @vcs ||= begin
          PluginLoader.load_plugin CxConf.vcs.action, "vcs_actions", @formatter, options, CxConf
        end
      end

      def bld
        @build ||= begin
          PluginLoader.load_plugin CxConf.build.action, "build_actions", @formatter, options, CxConf
        end
      end
    end
  end
end
