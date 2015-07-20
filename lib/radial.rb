require_relative "core/workflow_plugin_base"
require_relative "core/loaders/options_loader"
require_relative "core/loaders/command_loader"
require_relative "core/loaders/workflow_loader"

module Radial
  # Entry point to the application
  class Radial < WorkflowPluginBase
    include OptionsLoader
    include CommandLoader
    include WorkflowLoader
  end
end
