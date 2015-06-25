require "logger"
require_relative "../core/helpers/log_helper"
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

    def dbg(message)
      @out_log.debug message.to_s
    end

    def inf(message)
      @out_log.info message.to_s
    end

    def wrn(message)
      @out_log.warn message.to_s
    end

    def err(message)
      @err_log.error message.to_s
    end

    def ftl(message)
      @err_log.fatal message.to_s
    end

    def dbg?
      @out_log.debug?
    end

    def inf?
      @out_log.info?
    end

    def wrn?
      @out_log.warn?
    end

    def err?
      @err_log.error?
    end

    def ftl?
      @err_log.fatal?
    end
  end
end
