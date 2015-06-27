require_relative "logging_wrapper"
require_relative "cxconf"

# Base class to setup config and logger
class CxActionsPluginBase
  include LoggingWrapper

  attr_reader :logger, :options, :conf

  def initialize(logger, options = {}, conf = CxConf)
    @logger = logger
    @options = options
    @conf = conf
  end

  def self.generate(logger, options = {}, conf = CxConf)
    new logger, options, conf
  end
end
