require_relative "formatter"
require_relative "cxconf"

# Base class to setup config and formatter
class CxActionsPluginBase
  include Formatter

  def initialize(formatter, options = {}, conf = CxConf)
    @formatter = formatter
    @options = options
    @conf = conf
  end

  def self.generate(formatter, options = {}, conf = CxConf)
    new formatter, options, conf
  end
end
