require "thor"
require_relative "../helpers/file_helper"

# Specifies the version command
# rubocop:disable all
module CommandLoader
  def self.included(thor)
    thor.class_eval do
      PluginLoader.find_plugin_files("command").each do |plugin_file|
        require plugin_file.absolute_path
        eval "include #{plugin_file.plugin_name}"
      end
    end
  end
end
# rubocop:enable all
