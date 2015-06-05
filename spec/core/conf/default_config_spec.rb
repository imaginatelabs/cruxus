require "rspec"
require_relative "../../../lib/core/conf_dir_helper"

describe ".cxconf" do
  let(:conf) { ConfDirHelper.load_config_files ["lib/.cxconf"] }

  subject { conf }

  context "given the default config" do
    it "has the version 1.0.0" do
      expect(subject.version).to eq("1.0.0")
    end
  end
end
