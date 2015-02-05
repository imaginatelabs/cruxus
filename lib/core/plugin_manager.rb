require_relative "file_helper"

# Manages the detection of plugins
module PluginManager
  def plugins(type)
    plugin_files(type, "plugins/#{type}s/", "**/*#{type}.rb")
  end

  def plugin_files(type, dirname, glob = "**/*")
    plugins = []
    FileHelper.files(dirname, glob).each { |file| plugins << PluginFile.new(file, type) }
    plugins
  end
end

include PluginManager
