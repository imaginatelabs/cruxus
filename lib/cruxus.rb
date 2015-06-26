require_relative "core/cx_workflow_plugin_base"
require_relative "core/loaders/options_loader"
require_relative "core/loaders/command_loader"
require_relative "core/loaders/workflow_loader"

module Cx
  # Entry point to the application
  class Cruxus < CxWorkflowPluginBase
    include OptionsLoader
    include CommandLoader
    include WorkflowLoader
  end
end
