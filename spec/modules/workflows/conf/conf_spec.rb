require "rspec"
require_relative "../../../../spec/helper"
require_relative "../../../../lib/cruxus"
require_relative "../../../../lib/modules/workflows/conf/conf"

describe ConfWorkflow::Conf do
  include Helper

  let(:cx) { Cx::Cruxus }

  describe "#conf" do
    context "when no commands are specified" do

      let(:key_usage_message) { "conf key [KEY]       # Returns the value of the configuration key" }
      let(:select_usage_message) { "conf select [REGEX]  # Returns any keys and values that match the regular expression" }
      let(:output) { capture(:stdout) { cx.start([:conf]) } }

      subject { output }

      it { is_expected.to include(key_usage_message, select_usage_message)}

    end
  end
end