require_relative "../../../core/cx_plugin_base"

module WiWorkflow
  # WIP
  class Wi < CxPluginBase
    help_desc "Manage CX Work Items"

    desc "new", "Create new work item"
    def new
      puts("I'm in your work item")
    end
  end
end
