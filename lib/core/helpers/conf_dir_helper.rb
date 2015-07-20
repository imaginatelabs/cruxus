require "yaml"
require "confstruct"
require "env"
require "os"
require_relative "../plugin_file"

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
    File.absolute_path(File.dirname(__FILE__) + "/../../")
  end

  def working_dir
    File.absolute_path(Dir.pwd)
  end

  def ascend_dir(dir, path = nil, terminate = nil)
    dirs = []
    Kernel.loop do
      f_path = "#{dir}/#{path}"
      dirs.push f_path.gsub "//", "/"
      result = (dir = File.expand_path("#{dir}/../"))
      break unless result != terminate && result != "//"
    end
    dirs.reverse
  end

  def get_conf_paths(path = "")
    user = user_dir
    (%W(#{cx_dir}/#{path}
        #{shared_dir}/#{CONFIG_DIR}/#{path}
        #{user}/#{CONFIG_DIR}/#{path}) << ascend_dir(working_dir, path, user))
      .flatten
  end
end

include ConfDirHelper
