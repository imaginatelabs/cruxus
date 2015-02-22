require_relative "file_helper"
require_relative "string_helper"

# Manages the detection of plugins
module PluginManager
  def plugin(name, type)
    c_name = StringHelper.camelize name
    class_module = "#{c_name}#{StringHelper.camelize type}::#{c_name}"
    result = plugins(type).each { |file| return file if file.module_class_name == class_module }
    result.first
  end

  def plugins(type)
    plugin_files(type, "plugins/", "**/*_#{type}.rb")
  end

  def plugin_files(type, dirname, glob = "**/*")
    plugins = []
    FileHelper.files(dirname, glob).each { |file| plugins << PluginFile.new(file, type) }
    plugins
  end
end

include PluginManager
