require "thor"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module ReviewCommand
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

Creates and submits a code review on the current feature branch.

The command executes the following steps before submitting the code review.

  1. cx latest

  2. cx build

By doing this review ensures that a feature branche stay up-to-date and builds before it's
submitted for review.

Currently this is a basic git code review process, in the future cx review will integrate
with GitHub and BitBucket to initiate and close pull requests.

If you think integration with GitHub or BitBucket would be a good idea,
let us know by telling us on:

- Tell us on Twitter @ImaginateLabs

- Come chat about it on our Gitter channel https://gitter.im/imaginatelabs/radial

      LONGDESC

      descf "review", "[-r]",
            "Creates and submits a code review"
      option :remote,
             desc: "Remote server to submit code review",
             aliases: "-r",
             default: CxConf.vcs_code_review.remote
      def review
        inf "RUNNING: cx latest"
        invoke :latest
        inf "\nRUNNING: cx build"
        invoke :build
        inf "\nSUBMIT CODE REVIEW\n"
        vcs.submit_code_review options[:remote]
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
