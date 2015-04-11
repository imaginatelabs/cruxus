require_relative "../core/cx_actions_plugin_base"
require_relative "../core/cxconf"
require_relative "../core/cmd"

module BashBuildActions
  # Run build commands from bash
  class Bash < CxActionsPluginBase
    extend Cmd
    def cmd
      inf run CxConf.build.cmd
    end
  end
end
