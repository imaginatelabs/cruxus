# Mixin for using formatter
module Formatter
  def dbg(message)
    @formatter.dbg message
  end

  def inf(message)
    @formatter.inf message
  end

  def wrn(message)
    @formatter.wrn message
  end

  def err(message)
    @formatter.err message
  end

  def ftl(message, status = 1)
    @formatter.ftl message
    exit status
  end

  def ext(message, status = 0)
    if status == 0
      @formatter.inf message
    else
      @formatter.err message
    end
    exit status
  end
end

include Formatter
