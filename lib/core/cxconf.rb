require "confstruct"
require "singleton"
require_relative "helpers/conf_dir_helper"

include Confstruct

#
# CxConf is only to be used via constructor or method
# Dependency Injection. Doing otherwise will make your
# code difficult to test.
# You can mock this class out simply by using an
# instance of Confstruct:Configuration
#
class CxConf < Configuration
  include Singleton
  include ConfDirHelper

  def initialize
    conf_files = get_cxconf_paths(".cxconf")
    conf = load_config_files(conf_files)
    super(conf)
  end

  def self.respond_to?(symbol, include_all = false)
    super || instance.respond_to?(symbol, include_all)
  end

  def self.method_missing(method, *args, &_block)
    instance.send(method, *args)
  end
end
