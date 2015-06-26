require "thor"

# Specifies the version command
# rubocop:disable all
module LandCommand
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

        Squashes and lands feature branch onto '#{CxConf.vcs.main_branch}'

      LONGDESC

      descf "land",
            "[COMMIT_MESSAGE] [-rh]",
            "Squashes and lands feature branch onto '#{CxConf.vcs.main_branch}'"
      option :remote,
             desc: "Remote server to land changes",
             aliases: "-r",
             default: CxConf.vcs.remote
      option :hold,
             desc: "Hold from pushing changes to the remote",
             aliases: "-h",
             default: CxConf.vcs.push_hold
      def land(message = nil)
        invoke :latest, [], {}
        invoke :build, [], {}
        vcs.prepare_to_land_changes message, CxConf.vcs.main_branch
        vcs.land_changes options[:remote], CxConf.vcs.main_branch
      end
    end
  end
end
# rubocop:enable all
