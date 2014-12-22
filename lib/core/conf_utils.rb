require "yaml"
require "confstruct"
require "env"
require "os"
require_relative "plugin_file"

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
  def get_shared_dir
    OS::Underlying.windows? ? Env["ALLUSERSPROFILE"] : "/etc"
  end

  def get_user_dir
    Dir.home
  end

  def get_cx_dir
    File.absolute_path(File.dirname(__FILE__)+"/../")
  end

  def get_working_dir
    File.absolute_path(Dir.pwd + "/../")
  end

  def plugins(type)
    plugin_files(type, "plugins/#{type}s/","**/*#{type}.rb")
  end

  def plugin_files(type, dirname, glob="**/*")
    plugins = Array.new
    files(dirname, glob).each { |file| plugins << PluginFile.new(file, type) }
    plugins
  end

  def files(dirname, glob="**/*")
    files = Array.new
    get_cxconf_paths(dirname).each do |dir|
      files << Dir.glob("#{dir}#{glob}").select {|f| File.file?(f)} if Dir.exist?(dir)
    end
    files.flatten.map{ |f| File.absolute_path(f) }
  end

  def get_cxconf_paths(path = "")
    %W(#{get_cx_dir}/#{path}
       #{get_shared_dir}/#{CONFIG_DIR}/#{path}
       #{get_user_dir}/#{CONFIG_DIR}/#{path}
       #{get_working_dir}/#{CONFIG_DIR}/#{path})
  end

end

include ConfUtils
