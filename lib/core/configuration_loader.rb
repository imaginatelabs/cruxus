require 'yaml'
require 'confstruct'
require 'env'

module ConfigurationLoader
  CX_HOME = '../'
  CONFIG_FILE_NAME = '.cxconf'

  CONFIG_FILE_LOCATIONS = [
    "#{CX_HOME}#{CONFIG_FILE_NAME}"
  ]

  def load_config_files(config_files)
    config = Confstruct::Configuration.new
    config_files.each do |config_file|
      config.configure(YAML.load_file(config_file))
    end
    config
  end

  def get_user_home
    home = ['HOME', 'HOMEPATH'].detect {|h| ENV[h] != nil}
    Env["#{home}"]
  end
end

include ConfigurationLoader