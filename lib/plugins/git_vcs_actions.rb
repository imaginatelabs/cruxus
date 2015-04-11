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

    def latest_changes(main_branch, working_branch = @vcs.current_branch, remote = @conf.vcs.remote)
      update_branch(main_branch, remote, working_branch)
      diverged = @vcs.diverged? main_branch, working_branch
      cx_exit "'#{working_branch}' is up-to-date with '#{remote}/#{main_branch}'", 0 unless diverged
      rebase_changes(main_branch, working_branch)
    end

    def prepare_to_land_changes(main_branch, working_branch = @vcs.current_branch)
      number_of_commits = @vcs.diverged_count main_branch, working_branch
      info "Squashing #{number_of_commits} commits on branch '#{working_branch}'"
      @vcs.squash_branch number_of_commits, "Hard coded commit message for non-interactive squash"
    end

    def land_changes(main_branch, working_branch = @vcs.current_branch, remote)
      info "Landing changes from #{working_branch} onto #{main_branch}"
      @vcs.checkout main_branch
      @vcs.merge_fast_forward_only working_branch
      debug "Pushing changes onto #{main_branch}"
      @vcs.push main_branch
      debug "Removing branch #{working_branch}"
      @vcs.delete_remote_branch working_branch, remote
      info "Changes landed successfully onto #{main_branch}"
    end

    def self.generate(formatter, options = {}, conf = CxConf)
      new GitVcsClient::Git.new, formatter,  options, conf
    end

    private

    def update_branch(main_branch, remote, working_branch)
      remote_branch = "#{remote}/#{main_branch}"
      inf "Checking for new commits on '#{remote_branch}'"
      @vcs.fetch
      changes = @vcs.diverge_list main_branch, "#{remote_branch}"
      return if changes.empty?
      @vcs.checkout main_branch
      inf "Pulling the following new commits from '#{main_branch}':\n#{changes}"
      @vcs.pull main_branch, remote
      @vcs.checkout working_branch
    end

    def rebase_changes(main_branch, working_branch)
      changes = @vcs.diverge_list main_branch, working_branch
      inf "Rebasing changes from '#{working_branch}' onto '#{main_branch}'\n#{changes}"
      rebase_success = @vcs.rebase_onto(main_branch)
      until rebase_success
        wrn "Launching merge tool so you can resolve conflicts"
        @vcs.launch_merge_conflict_tool
        rebase_success = @vcs.continue_rebase
      end
    end
  end
end
