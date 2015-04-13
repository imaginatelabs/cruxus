require_relative "../core/cx_actions_plugin_base"
require_relative "../core/cxconf"
require_relative "../core/cmd"

module BashBuildActions
  # Run build commands from bash
  class Bash < CxActionsPluginBase
    extend Cmd
    def cmd(bash_cmd)
      run bash_cmd do | stdout, stderr, _thread|
        inf "#{stdout}" if stdout
        err "#{stderr}" if stderr
      end
    end
  end
end
