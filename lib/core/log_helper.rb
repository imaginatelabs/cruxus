require_relative "cxconf"
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

  def logger(std, log_file, log_level, formatter)
    log = log_file || Logger.new(std)
    log.level = log_level
    log.formatter = formatter
    log
  end

  # rubocop:disable all
  # Unused variables are made available for the output formatters
  def output_formatter(format, plugin_name)
    proc do |severity, datetime, progname, msg|
      pid = Process.pid
      severity_id = severity[0]
      severity_label = severity
      eval('"' + format.to_s + '\n"')
    end
  end
  # rubocop:enable all

  def load_formatter(class_name, options)
    CxConf.plugins("formatter").each do |plugin_file|
      next unless plugin_file.instance_name.downcase == options[:output_formatter]
      require plugin_file.absolute_path
      return formatter(plugin_file, class_name, options)
    end
  end

  def formatter(plugin_file, class_name, options)
    # rubocop:disable all
    return eval(plugin_file.module_class_name).new(class_name, options)
    # rubocop:enable all
  end
end

include LogHelper
