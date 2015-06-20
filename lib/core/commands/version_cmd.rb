require "thor"

# Specifies the version command
module VersionCmd
  def self.included(thor)
    thor.class_eval do
      thor.long_desc <<-LONGDESC

        Prints the current version of Cruxus.

      LONGDESC

      thor.desc "version",
                "Prints the current version of Cruxus. (Aliases: --version, -v)"

      thor.map "-v" => "version",
               "--version" => "version"

      def version
        inf(CxConf.version)
      end
    end
  end
end
