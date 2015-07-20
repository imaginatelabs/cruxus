require "rspec"
require_relative "../helper"
require_relative "../../lib/radial"
require_relative "../../lib/plugins/conf_workflow"

describe ConfWorkflow::Conf do
  include Helper

  let(:rad) { Radial::Radial.new }

  describe "#conf" do
    context "when no commands are specified" do
      let(:key_command) { "conf key      [KEY]" }
      let(:key_desc) { "# Returns the value of the configuration key" }
      let(:select_command) { "conf select   [REGEX]" }
      let(:select_desc) { "# Returns keys and values matching the regex" }

      let(:output) { capture(:stdout) { rad.conf } }

      subject { output }

      it { is_expected.to include(key_command, key_desc, select_command, select_desc) }
    end
  end
end
