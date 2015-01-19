require "logger"
require_relative "../../core/log_helper"
# Formats output as plain text
module PlainFormatter
  include LogHelper
  # Plain formatter
  class Plain
    def initialize(plugin_name, options)
      path = LogHelper.log_file_path(options[:log_file])
      log_file = path ? Logger.new(path) : nil
      log_level = LogHelper.parse_log_level(options[:log_level])
      formatter = LogHelper.output_formatter(LogHelper.output_format(log_file), plugin_name)
      @out_log = LogHelper.logger(STDOUT, log_file, log_level, formatter)
      @err_log = LogHelper.logger(STDERR, log_file, log_level, formatter)
    end

    def debug(message)
      @out_log.debug message.to_s
    end

    def info(message)
      @out_log.info message.to_s
    end

    def warn(message)
      @out_log.warn message.to_s
    end

    def err(message)
      @err_log.error message.to_s
    end

    def fatal(message)
      @err_log.fatal message.to_s
    end

    def debug?
      @out_log.debug?
    end

    def info?
      @out_log.info?
    end

    def warn?
      @out_log.warn?
    end

    def err?
      @err_log.error?
    end

    def fatal?
      @err_log.fatal?
    end
  end
end
