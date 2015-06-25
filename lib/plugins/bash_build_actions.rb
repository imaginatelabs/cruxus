require_relative "../core/cx_actions_plugin_base"
require_relative "../core/cxconf"
require_relative "../core/shell"

module BashBuildActions
  # Run build commands from bash
  class Bash < CxActionsPluginBase
    extend Shell
    def cmd(bash_cmd)
      result = run bash_cmd do | stdout, stderr, _thread|
        inf "#{stdout}" if stdout
        err "#{stderr}" if stderr
      end

      return result if result.exitstatus == 0

      ext "Command '#{bash_cmd}' failed with exitstatus #{result.exitstatus}", result.exitstatus
    end
  end
end
