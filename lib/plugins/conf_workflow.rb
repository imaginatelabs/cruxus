require_relative "../core/cx_workflow_plugin_base"
require_relative "./conf_actions"

module ConfWorkflow
  ##
  # Workflow for accessing configuration values from the command line
  ##
  class Conf < CxWorkflowPluginBase
    help_desc "Manage CX configuration"

    def initialize(args = [], options = {}, config = {})
      super(args, options, config)
      @actions = ConfWorkflow::ConfActions.new
    end

    desc "select [REGEX]", "Returns keys and values matching the regex"
    def select(regex = "")
      (@actions.select(regex)).each { |k, v| inf("#{k}: #{v}") }
    end

    desc "key [KEY]", "Returns the value of the configuration key"
    def key(key)
      inf(@actions.key(key))
    end
  end
end
