require "thor"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module BuildCmd
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

        Run the build

      LONGDESC

      descf "build", nil, "Run the build"
      def build
        bld.cmd CxConf.build.cmd
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
