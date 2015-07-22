require "rspec"
require_relative "../../../lib/core/helpers/conf_dir_helper"

describe ".radial.yml" do
  let(:conf) { ConfDirHelper.load_config_files ["lib/.radial.yml"] }

  subject { conf }

  context "given the default config" do
    it "has the version 0.1.1" do
      expect(subject.version).to eq("0.1.1")
    end

    it "has a default build command" do
      expect(subject.build.cmd).to eq("echo 'Please configure your build with the "\
                                      "property build.cmd in your project's .radial.yml "\
                                      "configuration file.'")
    end

    it "has the same variables for vcs and vcs_code_review" do
      expect(subject.vcs.remote).to eq(subject.vcs_code_review.remote)
      expect(subject.vcs.main_branch).to eq(subject.vcs_code_review.main_branch)
    end
  end
end
