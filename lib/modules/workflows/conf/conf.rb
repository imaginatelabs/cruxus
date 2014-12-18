require_relative "../../../core/cx_plugin_base"
require_relative "./steps"

module ConfWorkflow

  class Conf < CxPluginBase
    help_desc "Manage CX configuration"

    desc "select [REGEX]", "Returns any keys and values that match the regular expression"
    def select(regex="")
      (ConfWorkflow::Steps.new.select(regex)).each{ |k, v| puts("#{k}: #{v}")}
    end

    desc "key [KEY]", "Returns the value of the configuration key"
    def key(key)
      puts(ConfWorkflow::Steps.new.key(key))
    end
  end
end
