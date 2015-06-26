require "thor"

# Specifies the version command
# rubocop:disable all
module OptionsLoader
  def self.included(thor)
    thor.class_eval do
      PluginLoader.find_plugin_files("options").each do |plugin_file|
        require plugin_file.absolute_path
        eval "include #{plugin_file.plugin_name}"
      end
    end
  end
end
# rubocop:enable all
