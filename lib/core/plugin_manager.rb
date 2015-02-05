require_relative "cx_file_utils"

# Manages the detection of plugins
module PluginManager
  def plugins(type)
    plugin_files(type, "plugins/#{type}s/", "**/*#{type}.rb")
  end

  def plugin_files(type, dirname, glob = "**/*")
    plugins = []
    CxFileUtils.files(dirname, glob).each { |file| plugins << PluginFile.new(file, type) }
    plugins
  end
end

include PluginManager
