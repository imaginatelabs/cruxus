require_relative "../core/actions_plugin_base"
require_relative "../core/conf"
require_relative "clients/shell_client"

module BashBuildActions
  # Run build commands from bash
  class Bash < ActionsPluginBase
    extend ShellClient

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
