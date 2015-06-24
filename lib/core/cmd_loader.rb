require "thor"
require_relative "file_helper"

# Specifies the version command
# rubocop:disable all
module CmdLoader
  def self.included(thor)
    thor.class_eval do
      FileHelper.files("core/commands/", "**/*_cmd.rb").each do |file|
        require file
        eval "include #{StringHelper.camelize File.basename(file, ".rb")}"
      end
    end
  end
end
# rubocop:enable all
