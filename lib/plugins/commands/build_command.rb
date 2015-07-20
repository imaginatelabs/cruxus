require "thor"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module BuildCommand
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

Run the build, configured in the project's .radial.yml file
with the property:

|build:

|  cmd: bundle exec rake

      LONGDESC

      descf "build", nil, "Run the build"
      def build
        inf "\nBUILDING APPLICATION\n"
        bld.cmd Conf.build.cmd
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
