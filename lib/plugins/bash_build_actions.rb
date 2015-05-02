require_relative "../core/cx_actions_plugin_base"
require_relative "../core/cxconf"
require_relative "../core/cmd"

module BashBuildActions
  # Run build commands from bash
  class Bash < CxActionsPluginBase
    extend Cmd
    def cmd(bash_cmd)
      result = run bash_cmd do | stdout, stderr, _thread|
        inf "#{stdout}" if stdout
        err "#{stderr}" if stderr
      end

      unless result.exitstatus == 0
        cx_exit "Command '#{bash_cmd}' failed with exitstatus #{result.exitstatus}",
                result.exitstatus
      end

      result
    end
  end
end
