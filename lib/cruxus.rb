require_relative "core/cx_workflow_plugin_base"
require_relative "core/workflow_loader"
require_relative "core/logging_options"
require_relative "core/cmd_loader"

module Cx
  # Entry point to the application
  class Cruxus < CxWorkflowPluginBase
    include LoggingOptions
    include WorkflowLoader
    include CmdLoader
  end
end
