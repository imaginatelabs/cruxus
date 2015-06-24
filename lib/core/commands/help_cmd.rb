require "thor"
require_relative "../format_helper"

# Specifies the version command
# rubocop:disable Metrics/MethodLength
module HelpCmd
  def self.included(thor)
    thor.class_eval do
      extend FormatHelper

      thor.desc fmt("help", "[COMMAND]"),
           "Describe available commands or one specific command"
      def help(command = nil, subcommand = false)
        super command, subcommand
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
