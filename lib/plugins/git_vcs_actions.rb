require_relative "../core/cx_actions_plugin_base"
require_relative "git_vcs_client"

module GitVcsActions
  # Provides a git implementation for a high level interaction with vcs
  class Git < CxActionsPluginBase
    def initialize(vcs, formatter, options = {}, conf = CxConf)
      super(formatter, options, conf)
      @vcs = vcs
    end

    def start_new_feature(start_commit, feature_name)
      if @vcs.branch? feature_name
        inf "Feature branch '#{feature_name}' already exists"
      else
        inf "Creating feature branch '#{feature_name}'"
        @vcs.branch_locally(start_commit, feature_name)
      end
      @vcs.checkout feature_name
    end

    def self.generate(formatter, options = {}, conf = CxConf)
      new GitVcsClient::Git.new, formatter,  options, conf
    end
  end
end
