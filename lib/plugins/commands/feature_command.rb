require "thor"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module FeatureCommand
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

Creates a new feature branch for you to develop your changes.

Currently this is just a simple git branch but in the future the command will be able
to work in relation to GitHub or BitBucket issues, i.e. create a branch from a GitHub issue, which
will give the user a richer experience using other commands such as review and land.

If you think integration with GitHub or BitBucket issues would be a good idea,
let us know by telling us on:

- Tell us on Twitter @ImaginateLabs

- Come chat about it on our Gitter channel https://gitter.im/imaginatelabs/cruxus

      LONGDESC

      descf "feature", "FEATURE_NAME [-s]",
            "Creates a feature branch for you to develop your changes"
      option :start_commit,
             desc: "Commit you want to branch from",
             aliases: "-s",
             default: "HEAD"
      def feature(feature_name)
        inf "\nSTARTING NEW FEATURE\n"
        vcs.start_new_feature options[:start_commit], feature_name
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
