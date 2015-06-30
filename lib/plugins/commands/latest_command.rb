require "thor"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module LatestCommand
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

Pull changes from the main branch into current branch

The current feature branch will be rebased on top of any changes found on the main branch.

      LONGDESC

      descf "latest", "[MAIN_BRANCH]",
            "Pull changes from the main branch into current branch"
      def latest(main_branch = CxConf.vcs.main_branch)
        inf "\nGETTING LATEST CHANGES\n"
        vcs.latest_changes main_branch
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
