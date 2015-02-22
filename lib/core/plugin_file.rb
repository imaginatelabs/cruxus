require_relative "conf_dir_helper"
require_relative "string_helper"

# Represents the
class PluginFile
  attr_reader :absolute_path, :plugin_type

  def initialize(absolute_path, plugin_type)
    @absolute_path = absolute_path
    @plugin_type = plugin_type
  end

  def instance_name
    plugin_name.gsub(plugin_type.capitalize, "")
  end

  def plugin_name
    StringHelper.camelize(File.basename(@absolute_path, ".rb"))
  end

  def module_class_name
    "#{plugin_name}::#{instance_name}"
  end
end
