require_relative "../core/cx_actions_plugin_base"
require_relative "git_vcs_client"

module GitVcsActions
  # Provides a git implementation for a high level interaction with vcs
  class Git < CxActionsPluginBase
    def initialize(vcs, formatter, options = {}, conf = CxConf)
      super(formatter, options, conf)
      @vcs = vcs
    end

    def self.generate(formatter, options = {}, conf = CxConf)
      new GitVcsClient::Git.new, formatter,  options, conf
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
      exit_when_server_unavailable remote, "Couldn't retrieve latest changes"
      handle_uncommitted_changes "Couldn't retrieve latest changes"
      update_branch main_branch, remote, working_branch
      diverged = @vcs.diverged? main_branch, working_branch
      cx_exit "'#{working_branch}' is up-to-date with '#{remote}/#{main_branch}'", 0 unless diverged
      rebase_changes main_branch, working_branch
    end

    def submit_code_review(code_review_remote, working_branch = @vcs.current_branch)
      handle_uncommitted_changes
      exit_when_server_unavailable(code_review_remote, "Couldn't submit code review")
      inf "Submitting changes on '#{working_branch}' to "\
          "remote: '#{code_review_remote}' for code review"
      @vcs.push_force code_review_remote, working_branch
    end

    def prepare_to_land_changes(main_branch, working_branch = @vcs.current_branch)
      handle_uncommitted_changes
      number_of_commits = @vcs.diverged_count main_branch, working_branch
      info "Squashing #{number_of_commits} commits on branch '#{working_branch}'"
      # TODO: Change message for non-interactive squash
      @vcs.squash_branch number_of_commits, "Hard coded commit message for non-interactive squash"
    end

    def land_changes(main_branch, working_branch = @vcs.current_branch, remote)
      handle_uncommitted_changes
      exit_when_server_unavailable remote, "Couldn't land changes"
      info "Landing changes from #{working_branch} onto #{main_branch}"
      @vcs.checkout main_branch
      @vcs.merge_fast_forward_only working_branch
      debug "Pushing changes onto #{main_branch}"
      @vcs.push main_branch
      debug "Removing branch #{working_branch}"
      @vcs.delete_remote_branch working_branch, remote
      info "Changes landed successfully onto #{main_branch}"
    end

    private

    # Use this method from top public level methods
    def exit_when_server_unavailable(remote, message = nil)
      return if @vcs.server_availability? remote
      cx_exit(error_message("Remote '#{remote}' unavailable", message), 1)
    end

    def handle_uncommitted_changes(message = nil)
      # TODO: prompt user if they should be staged and amended to commit or quit
      changes = @vcs.uncommitted_changes
      return if changes.empty?
      cx_exit(error_message(format("Uncommitted changes found:\n   %-9s %-9s %-9s\n - %s",
                                   "UNSTAGED", "STAGED", "FILE", changes.join("\n - ")),
                            message),
              1)
    end

    def error_message(default, message)
      message.nil? ? default : "#{message} - #{default}"
    end

    def update_branch(main_branch, remote, working_branch)
      remote_branch = "#{remote}/#{main_branch}"
      inf "Checking for new commits on '#{remote_branch}'"
      @vcs.fetch
      changes = @vcs.diverge_list main_branch, "#{remote_branch}"
      return if changes.empty?
      @vcs.checkout main_branch
      inf "Pulling the following new commits from '#{main_branch}':\n#{changes}"
      @vcs.pull remote, main_branch
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
