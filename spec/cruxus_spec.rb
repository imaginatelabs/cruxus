require "rspec"
require_relative "helper"
require_relative "../lib/cruxus"
require_relative "../lib/plugins/bash_build_actions"
require_relative "../lib/plugins/git_vcs_actions"

describe Cx::Cruxus do
  include Helper

  let(:cx) { Cx::Cruxus.new [], [], {} }
  let(:bld) { double(BashBuildActions) }
  let(:vcs) { double(GitVcsActions) }

  before do
    allow_any_instance_of(Cx::Cruxus).to receive(:bld).and_return(bld)
    allow_any_instance_of(Cx::Cruxus).to receive(:vcs).and_return(vcs)
  end

  describe "#cx" do
    let(:output) { capture(:stdout) { Cx::Cruxus.start({}) } }

    subject { output }

    context "with no command line args" do
      let(:help_command) { "help [COMMAND]" }
      let(:help_desc) { "# Describe available commands or one specific command" }
      let(:version_command) { "version" }
      let(:version_desc) { "# Prints the current version of Cruxus" }

      it { is_expected.to include(help_command, help_desc, version_command, version_desc) }
    end
  end

  describe "#review" do
    let(:output) { capture(:stdout) { cx.invoke(:review) } }

    before do
      allow(vcs).to receive(:latest_changes)
      allow(bld).to receive(:cmd)
      allow(vcs).to receive(:submit_code_review)
    end

    subject { output }

    context "when all the steps run correctly" do
      before { subject }

      it "gets the latest changes" do
        expect(vcs).to have_received(:latest_changes)
      end

      it "runs a build" do
        expect(bld).to have_received(:cmd).with("echo 'Please configure your build with the "\
                                                "property build.cmd in your project's .cxconf "\
                                                "configuration file.'")
      end

      it "uses 'remote' vcs configuration for code review" do
        expect(vcs).to have_received(:submit_code_review).with("origin")
      end
    end

    context "when call to latest changes fails" do
      before do
        allow(vcs).to receive(:latest_changes).and_raise SystemExit
      end

      it "doesn't run a build" do
        expect(bld).not_to receive(:cmd)
        expect { subject }.to raise_error SystemExit
      end

      it "doesn't submit a code review" do
        expect(vcs).not_to receive(:submit_code_review)
        expect { subject }.to raise_error SystemExit
      end
    end
  end
end
