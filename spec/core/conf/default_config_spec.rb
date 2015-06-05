require "rspec"
require_relative "../../../lib/core/conf_dir_helper"

describe ".cxconf" do
  let(:conf) { ConfDirHelper.load_config_files ["lib/.cxconf"] }

  subject { conf }

  context "given the default config" do
    it "has the version 1.0.0" do
      expect(subject.version).to eq("1.0.0")
    end

    it "has a default build command" do
      expect(subject.build.cmd).to eq("echo 'Please configure your build with the property "\
                                      "build.cmd in your project's .cxconf configuration file.'")
    end
  end
end
