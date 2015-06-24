require "thor"
require_relative "format_helper"
require_relative "plugin_loader"

# Specifies the version command
# rubocop:disable all
module WorkflowLoader
  def self.included(thor)
    thor.class_eval do
      extend FormatHelper

      PluginLoader.find_plugin_files("workflow").each do |plugin_file|
        require plugin_file.absolute_path
        eval("extend #{plugin_file.plugin_name}")
        eval("thor.desc fmt('#{plugin_file.instance_name.downcase}','[COMMAND] [ARGS]'), '#{eval("#{plugin_file.module_class_name}.help_text")}'")
        eval("thor.subcommand '#{plugin_file.instance_name.downcase}', #{plugin_file.module_class_name}")
      end
    end
  end
end
# rubocop:enable all
