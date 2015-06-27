# Mixin for using logger
module LoggingWrapper
  def dbg(message)
    @logger.dbg message
  end

  def inf(message)
    @logger.inf message
  end

  def wrn(message)
    @logger.wrn message
  end

  def err(message)
    @logger.err message
  end

  def ftl(message, status = 1)
    @logger.ftl message
    exit status
  end

  def ext(message, status = 0)
    if status == 0
      @logger.inf message
    else
      @logger.err message
    end
    exit status
  end
end

include LoggingWrapper
