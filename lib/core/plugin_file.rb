require_relative "conf_utils"

class PluginFile
  attr_reader :absolute_path, :plugin_type

  def initialize(absolute_path, plugin_type)
    @absolute_path = absolute_path
    @plugin_type = plugin_type
  end

  def absolute_path
    @absolute_path
  end

  def instance_name
    plugin_name.gsub(plugin_type.capitalize,"")
  end

  def plugin_name
    camelize(File.basename(@absolute_path, ".rb"))
  end

  def module_class_name
    "#{plugin_name}::#{instance_name}"
  end

  private

  def camelize(string, uppercase_first_letter = true)
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    else
      string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end
end