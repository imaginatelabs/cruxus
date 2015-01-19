# Mixin for using formatter
module Formatter
  def debug(message)
    @formatter.debug message
  end

  def info(message)
    @formatter.info message
  end

  def warn(message)
    @formatter.warn message
  end

  def err(message)
    @formatter.err message
  end

  def fatal(message, status = 1)
    @formatter.fatal message
    exit status
  end
end

include Formatter
