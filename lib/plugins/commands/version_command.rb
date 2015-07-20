require "thor"

# Specifies the version command
module VersionCommand
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

Prints the current version of Radial.

      LONGDESC

      descf "version", nil,
            "Prints the current version of Radial. (Aliases: --version, -v)"
      map "-v" => "version",
          "--version" => "version"
      def version
        inf(CxConf.version)
      end
    end
  end
end
