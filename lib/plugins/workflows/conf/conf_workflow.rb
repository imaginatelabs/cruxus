require_relative "../../../core/cx_plugin_base"
require_relative "./steps"

module ConfWorkflow
  ##
  # Workflow for accessing configuration values from the command line
  ##
  class Conf < CxPluginBase
    help_desc "Manage CX configuration"

    desc "select [REGEX]", "Returns keys and values matching the regex"
    def select(regex = "")
      (ConfWorkflow::Steps.new.select(regex)).each { |k, v| puts("#{k}: #{v}") }
    end

    desc "key [KEY]", "Returns the value of the configuration key"
    def key(key)
      puts(ConfWorkflow::Steps.new.key(key))
    end
  end
end
