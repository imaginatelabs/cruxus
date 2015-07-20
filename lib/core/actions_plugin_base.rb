require_relative "logging_wrapper"
require_relative "conf"

# Base class to setup config and logger
class ActionsPluginBase
  include LoggingWrapper

  attr_reader :logger, :options, :conf

  def initialize(logger, options = {}, conf = Conf)
    @logger = logger
    @options = options
    @conf = conf
  end

  def self.generate(logger, options = {}, conf = Conf)
    new logger, options, conf
  end
end
