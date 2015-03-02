require_relative "../core/cx_workflow_plugin_base"

module WiWorkflow
  # WIP
  class Wi < CxWorkflowPluginBase
    help_desc "Manage CX Work Items"

    desc "new", "Create new work item"
    def new
      puts("I'm in your work item")
    end
  end
end
