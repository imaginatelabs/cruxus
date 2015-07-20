require "thor"

# Specifies the version command
# rubocop:disable all
module LandCommand
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

Squashes and lands feature branch onto '#{Conf.vcs.main_branch}'

The command executes the following steps before landing the changes

  1. cx latest

  2. cx build

The command squashes the changes between the HEAD of the main branch and
the HEAD of the feature branch into one commit.

CX feature branches should be short lived and pertain to a single change or idea,
all commits on a feature branch should be considered 'work in progress'.

      LONGDESC

      descf "land",
            "[COMMIT_MESSAGE] [-rh]",
            "Squashes and lands feature branch onto '#{Conf.vcs.main_branch}'"
      option :remote,
             desc: "Remote server to land changes",
             aliases: "-r",
             default: Conf.vcs.remote
      option :hold,
             desc: "Hold from pushing changes to the remote",
             aliases: "-h",
             default: Conf.vcs.push_hold
      def land(message = nil)
        inf "RUNNING: cx latest"
        invoke :latest, [], {}
        inf "\nRUNNING: cx build"
        invoke :build, [], {}
        inf "\nPREPARING CHANGES TO LAND\n"
        vcs.prepare_to_land_changes message, Conf.vcs.main_branch
        inf "\nLANDING CHANGES\n"
        vcs.land_changes options[:remote], Conf.vcs.main_branch
      end
    end
  end
end
# rubocop:enable all
