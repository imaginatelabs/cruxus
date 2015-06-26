require_relative "core/cx_workflow_plugin_base"
require_relative "core/loaders/workflow_loader"
require_relative "core/logging_options"
require_relative "core/loaders/command_loader"

module Cx
  # Entry point to the application
  class Cruxus < CxWorkflowPluginBase
    include LoggingOptions
    include WorkflowLoader
    include CommandLoader
  end
end
