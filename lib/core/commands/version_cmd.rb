require "thor"

# Specifies the version command
module VersionCmd
  def self.included(thor)
    thor.class_eval do
      long_desc <<-LONGDESC

        Prints the current version of Cruxus.

      LONGDESC

      descf "version", nil,
            "Prints the current version of Cruxus. (Aliases: --version, -v)"
      map "-v" => "version",
          "--version" => "version"
      def version
        inf(CxConf.version)
      end
    end
  end
end
