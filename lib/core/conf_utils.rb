require "yaml"
require "confstruct"
require "env"
require "os"
require_relative "plugin_file"

# ConfUtils - Utility methods for managing configuration
module ConfUtils
  CONFIG_DIR = "cx"

  def load_config_files(config_files)
    config = Confstruct::Configuration.new
    config_files.each do |config_file|
      config.configure(YAML.load_file(config_file)) if File.exist?(config_file)
    end
    config
  end

  # Will return true for windows even for Cygwin and GitBash
  def shared_dir
    OS::Underlying.windows? ? Env["ALLUSERSPROFILE"] : "/etc"
  end

  def user_dir
    Dir.home
  end

  def cx_dir
    File.absolute_path(File.dirname(__FILE__) + "/../")
  end

  def working_dir
    File.absolute_path(Dir.pwd + "/../")
  end

  def plugins(type)
    plugin_files(type, "plugins/#{type}s/", "**/*#{type}.rb")
  end

  def plugin_files(type, dirname, glob = "**/*")
    plugins = []
    files(dirname, glob).each { |file| plugins << PluginFile.new(file, type) }
    plugins
  end

  def files(dirname, glob = "**/*")
    files = []
    get_cxconf_paths(dirname).each do |dir|
      find = "#{dir}#{glob}"
      files << Dir.glob(find).select { |f| File.file?(f) } if Dir.exist?(dir)
    end
    files.flatten.map { |f| File.absolute_path(f) }
  end

  def get_cxconf_paths(path = "")
    %W(#{cx_dir}/#{path}
       #{shared_dir}/#{CONFIG_DIR}/#{path}
       #{user_dir}/#{CONFIG_DIR}/#{path}
       #{working_dir}/#{CONFIG_DIR}/#{path})
  end
end
include ConfUtils
