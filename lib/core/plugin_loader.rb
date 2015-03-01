require_relative "file_helper"
require_relative "string_helper"

# Manages the detection of plugins
module PluginLoader
  # rubocop:disable all
  def load_plugin(name, type, formatter, options = {}, conf = CxConf)
    plugin_file = find_plugin_file name, type
    return nil unless plugin_file
    require plugin_file.absolute_path
    plugin = eval "#{plugin_file.module_class_name}"
    plugin.generate formatter, options, conf
  end
  # rubocop:enable all

  def find_plugin_file(name, type)
    c_name = StringHelper.camelize name
    class_module = "#{c_name}#{StringHelper.camelize type}::#{c_name}"
    find_plugin_files(type).each do |file|
      return file if file.module_class_name == class_module
    end
    nil
  end

  def find_plugin_files(type)
    find_plugin_files_by_pattern(type, "plugins/", "**/*_#{type}.rb")
  end

  def find_plugin_files_by_pattern(type, dirname, glob = "**/*")
    plugins = []
    FileHelper.files(dirname, glob).each { |file| plugins << PluginFile.new(file, type) }
    plugins.empty? ? nil : plugins
  end
end

include PluginLoader
