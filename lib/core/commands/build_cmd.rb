require "thor"
require_relative "../format_helper"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module BuildCmd
  def self.included(thor)
    thor.class_eval do
      extend FormatHelper

      thor.long_desc <<-LONGDESC

        Run the build
      LONGDESC

      thor.desc "build", "Run the build"
      def build
        bld.cmd CxConf.build.cmd
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
