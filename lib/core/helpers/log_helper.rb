require_relative "../cxconf"
require_relative "../loaders/plugin_loader"

# Helper for setting up logging
module LogHelper
  def log_file_path(file_path, conf = CxConf)
    return false if !file_path || file_path.nil?
    file_path == "log_file" ? conf.log.file.path : file_path
  end

  def parse_log_level(level, conf = CxConf)
    level_options = conf.log.level_options
    matched_level = level_options.select { |l| l.upcase.start_with? level.upcase }.first
    parsed_level = matched_level || level_options[1]
    # rubocop:disable all
    eval("Logger::#{parsed_level.upcase}")
    # rubocop:enable all
  end

  def output_format(log_file, conf = CxConf)
    log_file ? conf.log.file.message_format : conf.log.message_format
  end

  # rubocop:disable all
  # Unused variables are made available for the output formatting
  def output_formatter(format, plugin_name)
    proc do |severity, datetime, progname, msg|
      # Requiring time fixes a bug where not
      # all Time methods where available such
      # as iso8601 used in the default .cxconf
      require 'time'

      pid = Process.pid
      severity_id = severity[0]
      severity_label = severity
      eval('"' + format.to_s + '\n"')
    end
  end
  # rubocop:enable all

  def load_logger(class_name, options)
    PluginLoader.find_plugin_files("logger").each do |plugin_file|
      next unless plugin_file.instance_name.downcase == options[:output_format]
      require plugin_file.absolute_path
      return initialize_logger(plugin_file, class_name, options)
    end
  end

  def initialize_logger(plugin_file, class_name, options)
    # rubocop:disable all
    return eval(plugin_file.module_class_name).new(class_name, options)
    # rubocop:enable all
  end
end

include LogHelper
