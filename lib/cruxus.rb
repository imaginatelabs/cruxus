require "bundler/vendored_thor"
require_relative "core/conf_utils"
require_relative "core/cxconf"

module Cx

  class Cruxus < Thor
    desc "version", "Displays the current version of Cruxus"
    def version
      puts(CxConf.version)
    end

    CxConf.plugins("workflow").each do |plugin_file|
      require plugin_file.absolute_path
      eval("extend #{plugin_file.plugin_name}")
      eval("desc '#{plugin_file.instance_name.downcase} [COMMAND] [ARGS]', '#{eval("#{plugin_file.module_class_name}.help_text")}'")
      eval("subcommand '#{plugin_file.instance_name.downcase}', #{plugin_file.module_class_name}")
    end
  end
end
