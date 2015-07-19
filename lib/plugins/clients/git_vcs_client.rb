require_relative "../../plugins/clients/shell_client"
require_relative "../../core/vcs_file"
require_relative "../../../lib/core/logging_wrapper"

module GitVcsClient
  # Wrapper around the git commands
  # rubocop:disable Metrics/ClassLength
  class Git
    include LoggingWrapper
    extend ShellClient

    def initialize(logger)
      @logger = logger
    end

    def branch_locally(start_commit, branch_name)
      git "branch #{branch_name} #{start_commit}"
    end

    def checkout(target_branch)
      git "checkout #{target_branch}"
    end

    def branch?(name)
      res = git("branch", log_level: :silent)
      res.stdout.include?(name) || res.stdout.include?("* #{name}")
    end

    def current_branch
      git("rev-parse --abbrev-ref HEAD", log_level: :silent).stdout.first.strip
    end

    def fetch
      git "fetch"
    end

    def uncommitted_changes
      git("status --porcelain", log_level: :silent).stdout.map do |change|
        VcsFile.new(
          File.absolute_path(change.split(" ")[1]),
          parse_status(change.slice(0..1))
        )
      end
    end

    def pull(remote, branch, remote_branch = nil)
      git "pull #{remote} #{branch}:#{remote_branch || branch}"
    end

    def diverged?(base_branch, commit)
      diverged_count(base_branch, commit) > 0
    end

    def diverged_count(base_branch = "master", commit = "HEAD")
      git("rev-list #{base_branch}..#{commit} --count", log_level: :silent).stdout.first.to_i
    end

    def diverged_list(base_branch, commit)
      git("log #{base_branch}..#{commit} --pretty=format:'- %h %s by %cN <%cE>'",
          log_level: :silent).stdout
    end

    def rebase_onto(branch = "master")
      !(git("rebase #{branch}").stderr.include?("\nCONFLICT"))
    end

    def continue_rebase
      !git("rebase --continue").stderr.include? "needs merge"
    end

    def launch_merge_conflict_tool
      Process.wait(spawn("git mergetool --no-prompt"))
    end

    def push(remote, branch, remote_branch = nil)
      git "push #{remote} #{branch}:#{remote_branch || branch}"
    end

    def push_force(remote, branch, remote_branch = nil)
      git "push #{remote} #{branch}:#{remote_branch || branch} --force"
    end

    def delete_remote_branch(remote, branch)
      delete_local_branch branch
      git "push #{remote} :#{branch}"
    end

    def delete_local_branch(branch)
      git "branch -D #{branch}"
    end

    def reset_head(commit)
      git "reset --keep #{commit}"
    end

    def merge_fast_forward_only(branch)
      git "merge --ff-only #{branch}"
    end

    def squash_branch(number_of_commits, message)
      git "reset --soft HEAD~#{number_of_commits}"
      git "commit -m '#{message}'"
    end

    def server_availability?(remote)
      # TODO: Check for positive case instead
      !git("ls-remote #{remote}", log_level: :silent).stderr.include? "fatal: unable to access"
    end

    def git(command, options = {})
      git_command = "git #{command}"

      case options[:log_level]
      when :silent
        run git_command
      else
        inf "Run: '#{git_command}'"
        run git_command do | stdout, stderr, _thread|
          inf "[git-out]: #{stdout}" if stdout
          err "[git-err]: #{stderr}" if stderr
        end
      end
    end

    private

    def parse_status(status_str)
      { staged: parse_char(status_str[0]), unstaged: parse_char(status_str[1]) }
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def parse_char(char)
      case char
      when "?" then return :untracked
      when "M" then return :modified
      when "A" then return :added
      when "D" then return :deleted
      when "R" then return :renamed
      when "C" then return :copied
      when "U" then return :updated
      else return :none
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity
  end
  # rubocop:enable Metrics/ClassLength
end
