require "thor"
require_relative "../format_helper"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module ReviewCmd
  def self.included(thor)
    thor.class_eval do
      extend FormatHelper

      thor.long_desc <<-LONGDESC

        Creates and submits a code review
      LONGDESC

      thor.desc fmt("review", "[-r]"),
                "Creates and submits a code review"
      option :remote,
             desc: "Remote server to submit code review",
             aliases: "-r",
             default: CxConf.vcs_code_review.remote
      def review
        invoke :latest
        invoke :build
        vcs.submit_code_review options[:remote]
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
