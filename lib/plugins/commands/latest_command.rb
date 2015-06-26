require "thor"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module LatestCommand
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

        Pull changes from the main branch into current branch

        This command executes several steps in git, firstly it checks to see if there are any
        changes and if it fetches, the

        If you think integration with GitHub issues would be a good idea,
        let us know by telling us on:

        - Tell us on Twitter @ImaginateLabs

        - Come chat about it on our Gitter channel https://gitter.im/imaginatelabs/cruxus

      LONGDESC

      descf "latest", "[MAIN_BRANCH]",
            "Pull changes from the main branch into current branch"
      def latest(main_branch = CxConf.vcs.main_branch)
        vcs.latest_changes main_branch
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
