require_relative "../core/cx_actions_plugin_base"
require_relative "../core/helpers/string_helper"
require_relative "clients/git_vcs_client"

module GitVcsActions
  # Provides a git implementation for a high level interaction with vcs
  class Git < CxActionsPluginBase
    include StringHelper

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
      ext "'#{working_branch}' is up-to-date with '#{remote}/#{main_branch}'" unless diverged
      rebase_changes main_branch, working_branch
    end

    def submit_code_review(code_review_remote, working_branch = @vcs.current_branch)
      handle_uncommitted_changes
      exit_when_server_unavailable(code_review_remote, "Couldn't submit code review")
      inf "Submitting changes on '#{working_branch}' to "\
          "remote: '#{code_review_remote}' for code review"
      @vcs.push_force code_review_remote, working_branch
    end

    def prepare_to_land_changes(message, main_branch, working_branch = @vcs.current_branch)
      handle_uncommitted_changes
      commit_count = @vcs.diverged_count main_branch, working_branch
      inf "Squashing #{commit_count} commits on branch '#{working_branch}'"
      # TODO: Open text editor to write commit message
      @vcs.squash_branch commit_count, msg("Squashed the following #{commit_count} changes:\n"\
                                           "#{@vcs.diverged_list main_branch, working_branch}",
                                           message, "\n\n")
    end

    def land_changes(remote, main_branch, working_branch = @vcs.current_branch)
      handle_uncommitted_changes
      exit_when_server_unavailable remote, "Couldn't land changes"
      inf "Landing changes from #{working_branch} onto #{main_branch}"
      @vcs.checkout main_branch
      @vcs.merge_fast_forward_only working_branch
      exit_on_hold
      inf "Pushing changes onto #{main_branch}"
      @vcs.push remote, main_branch
      inf "Removing branch #{working_branch}"
      @vcs.delete_remote_branch remote, working_branch
      inf "Changes landed successfully onto #{main_branch}"
    end

    private

    def exit_on_hold
      ext "Changes have been held from being pushed to the remote "\
          "and need to be pushed manually" if options[:hold]
    end

    # Use this method from top public level methods
    def exit_when_server_unavailable(remote, message = nil)
      return if @vcs.server_availability? remote
      ftl(msg("Remote '#{remote}' unavailable", message), 1)
    end

    def handle_uncommitted_changes(message = nil)
      # TODO: prompt user if they should be staged and amended to commit or quit
      changes = @vcs.uncommitted_changes
      return if changes.empty?
      ftl(msg(format("Uncommitted changes found:\n   %-9s %-9s %-9s\n - %s",
                     "UNSTAGED", "STAGED", "FILE", changes.join("\n - ")),
              message))
    end

    def update_branch(main_branch, remote, working_branch)
      remote_branch = "#{remote}/#{main_branch}"
      inf "Checking for new commits on '#{remote_branch}'"
      @vcs.fetch
      changes = @vcs.diverged_list main_branch, "#{remote_branch}"
      return if changes.empty?
      @vcs.checkout main_branch
      inf "Pulling the following new commits from '#{main_branch}':\n#{changes}"
      @vcs.pull remote, main_branch
      @vcs.checkout working_branch
    end

    def rebase_changes(main_branch, working_branch)
      changes = @vcs.diverged_list main_branch, working_branch
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
