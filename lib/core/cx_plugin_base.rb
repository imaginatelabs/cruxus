require "bundler/vendored_thor"

class CxPluginBase < Thor
  def self.help_desc(help_desc)
    @help_desc= help_desc
  end

  def self.help
    @help_desc
  end

end