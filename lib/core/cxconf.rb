#
# CxConf is only to be used via constructor or method
# Dependency Injection. Doing otherwise will make your
# code difficult to test.
# You can mock this class out simply by using an
# instance of Confstruct:Configuration
#
require 'require_all'
require 'confstruct'
require 'singleton'
require_rel './conf_utils'

include Confstruct

class CxConf < Configuration
  include Singleton
  include ConfUtils

  def initialize
      conf_files = get_cxconf_paths('.cxconf')
      conf = load_config_files(conf_files)
      super(conf)
  end

  def self.respond_to?(method)
    super || instance.respond_to?(method)
  end

  def self.method_missing(method, *args, &block)
    self.instance.send(method, *args)
  end

end