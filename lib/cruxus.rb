require_relative "core/cxconf"
require_relative "core/plugin_loader"
require_relative "core/cx_plugin_base"

module Cx
  # Entry point to the application
  class Cruxus < CxPluginBase
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
      info(CxConf.version)
    end

    PluginLoader.find_plugin_files("workflow").each do |plugin_file|
      require plugin_file.absolute_path
      # rubocop:disable all
      eval("extend #{plugin_file.plugin_name}")
      eval("desc '#{plugin_file.instance_name.downcase} [COMMAND] [ARGS]', '#{eval("#{plugin_file.module_class_name}.help_text")}'")
      eval("subcommand '#{plugin_file.instance_name.downcase}', #{plugin_file.module_class_name}")
      # rubocop:enable all
    end
  end
end
