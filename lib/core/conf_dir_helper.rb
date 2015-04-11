require "yaml"
require "confstruct"
require "env"
require "os"
require_relative "plugin_file"

# ConfDirHelper - Utility methods for managing configuration
module ConfDirHelper
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
    File.absolute_path(Dir.pwd)
  end

  def get_cxconf_paths(path = "")
    %W(#{cx_dir}/#{path}
       #{shared_dir}/#{CONFIG_DIR}/#{path}
       #{user_dir}/#{CONFIG_DIR}/#{path}
       #{working_dir}/#{path})
  end
end

include ConfDirHelper
