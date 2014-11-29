require "rspec"
require_relative "helper"
require_relative "../lib/cruxus"

describe Cx::Cruxus do
  include Helper

  let(:cx) { Cx::Cruxus }

  describe "#cx" do
    let(:output) { capture(:stdout) { cx.start({}) } }

    subject { output }

    context "with no command line args" do
      let(:help_command)    { "help [COMMAND]         # Describe available commands or one specific command" }
      let(:version_command) { "version                # Displays the current version of Cruxus" }

      it { is_expected.to include(help_command, version_command) }
    end
  end
end