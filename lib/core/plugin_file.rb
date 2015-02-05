require_relative "conf_dir_helper"

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
    camelize(File.basename(@absolute_path, ".rb"))
  end

  def module_class_name
    "#{plugin_name}::#{instance_name}"
  end

  private

  def camelize(str, uppercase_first_letter = true)
    if uppercase_first_letter
      str = str.sub(/^[a-z\d]*/) { $&.capitalize }
    else
      str = str.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
    end
    regex = /(?:_|(\/))([a-z\d]*)/
    str.gsub(regex) { "#{Regexp.last_match[1]}#{Regexp.last_match[2].capitalize}" }.gsub("/", "::")
  end
end
