require_relative "../core/cmd"

module GitVcsClient
  # Wrapper around the git commands
  class Git
    extend Cmd
    def branch_locally(start_commit, branch_name)
      git "branch #{branch_name} #{start_commit}"
    end

    def checkout(target_branch)
      git "checkout #{target_branch}"
    end

    def branch?(name)
      git("branch").include? name
    end

    def current_branch
      git "rev-parse --abbrev-ref HEAD"
    end

    def fetch
      git "fetch"
    end

    def pull(branch, remote = "origin", remote_branch)
      git "pull #{remote} #{branch}:#{remote_branch || branch}"
    end

    def diverged?(base_branch, commit)
      diverged_count(base_branch, commit) > 0
    end

    def diverged_count(base_branch = "master", commit = "HEAD")
      git("rev-list #{base_branch}..#{commit} --count").to_i
    end

    def diverge_list(base_branch, commit)
      git "log #{base_branch}..#{commit} --pretty=format:'- %h %s by %cN <%cE>'"
    end

    def rebase_onto(branch = "master")
      !(git("rebase #{branch}").include?("\nCONFLICT"))
    end

    def continue_rebase
      !`git rebase --continue`.include? "needs merge"
    end

    def launch_merge_conflict_tool
      Process.wait(spawn("git mergetool --no-prompt"))
    end

    def push(branch, remote = "origin", remote_branch)
      `git push #{remote} #{branch}:#{remote_branch || branch}`
    end

    def delete_remote_branch(branch, remote)
      delete_local_branch branch
      `git push #{remote} :#{branch}`
    end

    def delete_local_branch(branch)
      `git branch -D #{branch}`
    end

    def reset_head(commit)
      `git reset --keep #{commit}`
    end

    def merge_fast_forward_only(branch)
      `git merge --ff-only #{branch}`
    end

    def squash_branch(number_of_commits, message)
      `git reset --soft HEAD~#{number_of_commits}`
      `git commit -m '#{message}'`
    end

    def git(command)
      `git #{command}`.strip
    end
  end
end
