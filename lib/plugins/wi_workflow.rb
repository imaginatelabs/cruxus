require_relative "../core/cx_workflow_plugin_base"

module WiWorkflow
  # WIP
  class Wi < CxWorkflowPluginBase
    help_desc "EXPERIMENTAL! - Manage Issues and Work Items"

    default_command :feedback

    descf "feedback", nil, "Give us your feedback on this idea"
    def feedback
      invoke :help
      inf "If you think this would be a good idea, let us know by telling us on:\n"\
          " - Tell us on Twitter @ImaginateLabs\n"\
          " - Come chat about it on our Gitter channel https://gitter.im/imaginatelabs/radial\n"
    end

    descf "new", "DESCRIPTION", "Create new work item"
    def new(_description)
      invoke_feedback
    end

    descf "start", "ID", "Start working on a work item"
    def start(_id)
      invoke_feedback
    end

    descf "show", "[QUERY]", "Show all work items"
    def show(_query = nil)
      invoke_feedback
    end

    descf "close", "ID [COMMENT]", "Close a work item by id"
    def close(_id, _comment = nil)
      invoke_feedback
    end

    descf "comments", "ID", "Show all comments"
    def comments(_id)
      invoke_feedback
    end

    descf "comment", "ID COMMENT", "Comment on a work item"
    def comment(_id, _comment)
      invoke_feedback
    end

    no_commands do
      def invoke_feedback
        invoke :feedback, [], {}
      end
    end
  end
end
