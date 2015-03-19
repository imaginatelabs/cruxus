require "rspec"
require_relative "../../lib/plugins/git_vcs_actions"
require_relative "../../lib/plugins/git_vcs_client"
require_relative "../../lib/core/cxconf"

describe GitVcsActions do
  let(:git_vcs_actions) { GitVcsActions::Git.generate(formatter, options, conf) }
  let(:formatter) { true }
  let(:options) { {} }
  let(:conf) { CxConf }
  let(:git_vcs_client) { true }

  before do
    allow(formatter).to receive(:info)
    allow(GitVcsClient::Git).to receive(:new).and_return(git_vcs_client)
  end

  describe "#start_new_feature" do
    let(:start_commit) { "HEAD" }
    let(:feature_branch_name) { "fb" }

    subject { git_vcs_actions.start_new_feature start_commit, feature_branch_name }

    before do
      allow(git_vcs_client).to receive(:branch?).and_return(branch_result)
      allow(git_vcs_client).to receive(:branch_locally).with(start_commit, feature_branch_name)
      allow(git_vcs_client).to receive(:checkout).with(feature_branch_name)
      subject
    end

    context "when no feature branch exits" do
      let(:branch_result) { false }

      it "creates a feature branch and checks it out" do
        expect(git_vcs_client).to have_received(:branch?)
        expect(git_vcs_client).to have_received(:branch_locally)
          .with(start_commit, feature_branch_name)
        expect(git_vcs_client).to have_received(:checkout).with(feature_branch_name)
      end
    end

    context "when feature branch exits" do
      let(:branch_result) { true }

      it "checks out existing branch" do
        expect(git_vcs_client).to have_received(:branch?)
        expect(git_vcs_client).to_not have_received(:branch_locally)
        expect(git_vcs_client).to have_received(:checkout).with(feature_branch_name)
      end
    end
  end
end
