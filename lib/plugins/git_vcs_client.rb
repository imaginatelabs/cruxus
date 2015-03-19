module GitVcsClient
  # Wrapper around the git commands
  class Git
    def branch_locally(start_commit, branch_name)
      `git branch #{branch_name} #{start_commit}`
    end

    def checkout(target_branch)
      `git checkout #{target_branch}`
    end

    def branch?(name)
      git("branch").include? name
    end

    def git(command)
      `git #{command}`.strip
    end
  end
end
