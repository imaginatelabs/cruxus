require "rspec"
require_relative "../../lib/plugins/git_vcs_actions"
require_relative "../../lib/plugins/git_vcs_client"
require_relative "../../lib/core/cxconf"

describe GitVcsActions::Git do
  let(:git_vcs_actions) { GitVcsActions::Git.generate(formatter, options, conf) }
  let(:formatter) { true }
  let(:options) { {} }
  let(:conf) { CxConf }
  let(:git_vcs_client) { true }

  before do
    allow(formatter).to receive(:inf)
    allow(formatter).to receive(:wrn)
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

  describe "#latest_changes" do
    let(:main_branch) { "master" }
    let(:remote) { "origin" }
    let(:working_branch) { "fb" }
    let(:remote_branch) { "#{remote}/#{main_branch}" }
    let(:merge_result) { true }
    let(:diverge_list_result) { "" }

    subject { git_vcs_actions.latest_changes main_branch, working_branch, remote }

    before do
      allow(git_vcs_client).to receive(:fetch)
      allow(git_vcs_client).to receive(:diverge_list).with(main_branch, remote_branch).once
        .and_return(diverge_list_result)
      allow(git_vcs_client).to receive(:diverge_list).with(main_branch, working_branch).once
        .and_return(diverge_list_result)
      allow(git_vcs_client).to receive(:diverged?).and_return(diverge_result)
      allow(git_vcs_client).to receive(:checkout)
      allow(git_vcs_client).to receive(:pull).with(main_branch, remote)
      allow(git_vcs_client).to receive(:rebase_onto).with(main_branch).and_return(merge_result)
    end

    context "when there are no upstream changes" do
      let(:diverge_result) { false }

      it "exits successfully without any changes" do
        begin
          subject
          expect(git_vcs_client).to have_received(:fetch)
          expect(git_vcs_client).to have_received(:diverge_list)
          expect(git_vcs_client).to have_received(:diverged?)
        rescue SystemExit
          expect(git_vcs_client).to_not have_received(:checkout)
          expect(git_vcs_client).to_not have_received(:rebase_onto)
        end
      end
    end

    context "when there are upstream changes" do
      let(:diverge_result) { true }

      context "when the changes have already been fetched" do
        it "updates the working branch" do
          subject
          expect(git_vcs_client).to have_received(:fetch)
          expect(git_vcs_client).to have_received(:diverge_list).twice
          expect(git_vcs_client).to_not have_received(:checkout)
          expect(git_vcs_client).to have_received(:diverged?)
          expect(git_vcs_client).to have_received(:rebase_onto).with(main_branch)
        end
      end

      context "when the changes haven't already been fetched" do
        let(:diverge_list_result) { "has content" }

        it "updates both the main branch and re-bases the working branch on top" do
          subject
          expect(git_vcs_client).to have_received(:fetch)
          expect(git_vcs_client).to have_received(:diverge_list).twice
          expect(git_vcs_client).to have_received(:pull)
          expect(git_vcs_client).to have_received(:checkout).twice
          expect(git_vcs_client).to have_received(:diverged?)
          expect(git_vcs_client).to have_received(:rebase_onto).with(main_branch)
        end
      end

      context "when there are conflicts during the rebase" do
        let(:merge_result) { false }

        before do
          allow(git_vcs_client).to receive(:launch_merge_conflict_tool)
          allow(git_vcs_client).to receive(:continue_rebase).and_return(true)
        end

        it "updates both the main branch and re-bases the working branch on top" do
          subject
          expect(git_vcs_client).to have_received(:launch_merge_conflict_tool)
        end
      end
    end
  end
end
