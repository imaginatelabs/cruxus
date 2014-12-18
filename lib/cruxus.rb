require "bundler/vendored_thor"
require "require_all"
require_relative "core/conf_utils"
require_relative "core/cxconf"

module Cx
  # Require all CxWorkflows from CxModule directories
  CxConf.get_cxconf_paths("modules/workflows/").each {|dir|
    require_all dir if Dir.exist? dir
  }

  class Cruxus < Thor

    desc "version", "Displays the current version of Cruxus"
    def version
      puts(CxConf.version)
    end

    # Load CxModules from CxModule directories
    workflows = Array.new
    CxConf.get_cxconf_paths("modules/workflows/").each do |dir|
      workflows << Dir.entries(dir).select {|f| f != "." && f != ".."} if Dir.exist?(dir)
    end
    workflows.flatten.each do |name|
      eval("extend #{name.capitalize}Workflow")
      help_desc = eval("#{name.capitalize}Workflow::#{name.capitalize}.help")
      eval("desc '#{name} [COMMAND] [ARGS]', '#{help_desc}'")
      eval("subcommand '#{name}', #{name.capitalize}Workflow::#{name.capitalize}")
    end
  end
end
