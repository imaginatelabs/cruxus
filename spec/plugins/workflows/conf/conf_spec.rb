require "rspec"
require_relative "../../../../spec/helper"
require_relative "../../../../lib/cruxus"
require_relative "../../../../lib/plugins/workflows/conf/conf_workflow"

describe ConfWorkflow::Conf do
  include Helper

  let(:cx) { Cx::Cruxus.new }

  describe "#conf" do
    context "when no commands are specified" do

      let(:key_command) { "conf key [KEY]" }
      let(:key_desc) { "# Returns the value of the configuration key" }
      let(:select_command) { "conf select [REGEX]" }
      let(:select_desc) { "# Returns any keys and values that match the regular expression" }
      let(:output) { capture(:stdout) { cx.conf } }

      subject { output }

      it { is_expected.to include(key_command, key_desc, select_command, select_desc) }
    end
  end
end