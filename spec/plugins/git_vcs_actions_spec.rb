require "rspec"
require_relative "../../lib/plugins/git_vcs_actions"
require_relative "../../lib/plugins/clients/git_vcs_client"
require_relative "../../lib/core/conf"

describe GitVcsActions::Git do
  let(:git_vcs_actions) { GitVcsActions::Git.generate(logger, options, conf) }
  let(:logger) { true }
  let(:options) { {} }
  let(:conf) { Conf }
  let(:git_vcs_client) { true }
  let(:uncommitted_changes) do
    [
      VcsFile.new("foo.txt", staged: :modified, unstaged: :none),
      VcsFile.new("bar.txt", staged: :modified, unstaged: :none),
      VcsFile.new("baz.txt", staged: :modified, unstaged: :none),
      VcsFile.new("mee.txt", staged: :none, unstaged: :modified)
    ]
  end
  let(:uncommitted_changes_output) do
    "Uncommitted changes found:\n"\
    "   UNSTAGED  STAGED    FILE     \n"\
    " - modified  none      foo.txt\n"\
    " - modified  none      bar.txt\n"\
    " - modified  none      baz.txt\n"\
    " - none      modified  mee.txt"
  end

  before do
    allow(logger).to receive(:inf)
    allow(logger).to receive(:wrn)
    allow(logger).to receive(:err)
    allow(logger).to receive(:ftl)
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
    let(:diverge_list_result) { [] }
    let(:server_availability) { true }
    let(:diverge_result) { false }
    let(:uncommitted_changes) { [] }

    subject { git_vcs_actions.latest_changes main_branch, working_branch, remote }

    before do
      allow(git_vcs_client).to receive(:fetch)
      allow(git_vcs_client).to receive(:diverged_list).with(main_branch, remote_branch).once
        .and_return(diverge_list_result)
      allow(git_vcs_client).to receive(:diverged_list).with(main_branch, working_branch).once
        .and_return(diverge_list_result)
      allow(git_vcs_client).to receive(:diverged?).and_return(diverge_result)
      allow(git_vcs_client).to receive(:checkout)
      allow(git_vcs_client).to receive(:pull).with(remote, main_branch)
      allow(git_vcs_client).to receive(:rebase_onto).with(main_branch).and_return(merge_result)
      allow(git_vcs_client).to receive(:server_availability?).and_return(server_availability)
      allow(git_vcs_client).to receive(:uncommitted_changes).and_return(uncommitted_changes)
    end

    context "when the server is unavailable" do
      let(:server_availability) { false }

      it "exits the application" do
        expect(logger).to receive(:ftl)
          .with("Couldn't retrieve latest changes - Remote 'origin' unavailable")
        expect { subject }.to raise_error SystemExit
      end
    end

    context "when there are no upstream changes" do
      it "exits successfully without any changes" do
        begin
          subject
          expect(git_vcs_client).to have_received(:fetch)
          expect(git_vcs_client).to have_received(:diverged_list)
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
          expect(git_vcs_client).to have_received(:diverged_list).twice
          expect(git_vcs_client).to_not have_received(:checkout)
          expect(git_vcs_client).to have_received(:diverged?)
          expect(git_vcs_client).to have_received(:rebase_onto).with(main_branch)
        end
      end

      context "when the changes haven't already been fetched" do
        let(:diverge_list_result) { ["has content"] }

        it "updates both the main branch and re-bases the working branch on top" do
          subject
          expect(git_vcs_client).to have_received(:fetch)
          expect(git_vcs_client).to have_received(:diverged_list).twice
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

  describe "#submit_code_review" do
    before do
      allow(git_vcs_client).to receive(:uncommitted_changes).and_return(uncommitted_changes)
      allow(git_vcs_client).to receive(:push_force)
    end

    subject { git_vcs_actions.submit_code_review "origin", "develop" }

    context "when there are uncommitted changes" do
      it "exits cx without pushing" do
        expect(git_vcs_client).to_not receive(:push_force)
        expect { subject }.to raise_error SystemExit
      end

      it "prints a list of uncommitted changes" do
        expect(logger).to receive(:ftl).with(uncommitted_changes_output)
        expect { subject }.to raise_error SystemExit
      end
    end

    context "when there are no uncommitted changes" do
      let(:uncommitted_changes) { [] }
      let(:server_availability) { true }

      before do
        allow(git_vcs_client).to receive(:server_availability?).and_return(server_availability)
      end

      context "when the remote server is available" do
        it "pushes to the remote" do
          subject
          expect(git_vcs_client).to have_received(:push_force).with("origin", "develop")
        end
      end

      context "when the remote server is unavailable" do
        let(:server_availability) { false }
        it "exits the application" do
          expect(git_vcs_client).not_to receive(:push)
          expect { subject }.to raise_error SystemExit
        end
      end
    end
  end

  describe "#prepare_to_land_changes" do
    before do
      allow(git_vcs_client).to receive(:uncommitted_changes).and_return(uncommitted_changes)
      allow(git_vcs_client).to receive(:diverged_count).and_return(diverged_count)
      allow(git_vcs_client).to receive(:diverged_list).and_return(diverged_list)
      allow(git_vcs_client).to receive(:squash_branch)
    end

    let(:message) { nil }
    let(:diverged_count) { nil }
    let(:diverged_list) { nil }

    subject { git_vcs_actions.prepare_to_land_changes message, "master", "develop" }

    context "when there are uncommitted changes" do
      it "exits cx without squahsing changes" do
        expect(git_vcs_client).to_not receive(:diverged_count)
        expect(git_vcs_client).to_not receive(:diverged_list)
        expect(git_vcs_client).to_not receive(:squash_branch)
        expect { subject }.to raise_error SystemExit
      end

      it "prints a list of uncommitted changes" do
        expect(logger).to receive(:ftl).with(uncommitted_changes_output)
        expect { subject }.to raise_error SystemExit
      end
    end

    context "when there are no uncommitted changes" do
      let(:uncommitted_changes) { [] }
      let(:diverged_count) { 3 }
      let(:diverged_list) do
        ["- 86fc61c gemfile by Foo Bar <foo.bar@cx.com>",
         "- 3b22538 rebase test by Foo Bar <foo.bar@cx.com>",
         "- 4168b56 Fifth commit by Foo Bar <foo.bar@cx.com>"]
      end

      before { subject }

      it "prints a message with the details of the squash" do
        expect(logger).to have_received(:inf).with("Squashing 3 commits on branch 'develop'")
      end

      context "given a commit message" do
        let(:message) { "My typed commit message" }
        it "squashes all the commits wit the given commit message" do
          expect(git_vcs_client).to have_received(:squash_branch)
            .with(3, "My typed commit message\n\n"\
                     "Squashed the following 3 changes:\n"\
                     "- 86fc61c gemfile by Foo Bar <foo.bar@cx.com>\n"\
                     "- 3b22538 rebase test by Foo Bar <foo.bar@cx.com>\n"\
                     "- 4168b56 Fifth commit by Foo Bar <foo.bar@cx.com>")
        end
      end

      context "given no commit message" do
        it "squashes all the commits wit the default commit message" do
          expect(git_vcs_client).to have_received(:squash_branch)
            .with(3, "Squashed the following 3 changes:\n"\
                     "- 86fc61c gemfile by Foo Bar <foo.bar@cx.com>\n"\
                     "- 3b22538 rebase test by Foo Bar <foo.bar@cx.com>\n"\
                     "- 4168b56 Fifth commit by Foo Bar <foo.bar@cx.com>")
        end
      end
    end
  end

  describe "#land_changes" do
    before do
      allow(git_vcs_client).to receive(:uncommitted_changes).and_return(uncommitted_changes)
      allow(git_vcs_client).to receive(:checkout)
      allow(git_vcs_client).to receive(:merge_fast_forward_only)
      allow(git_vcs_client).to receive(:push)
      allow(git_vcs_client).to receive(:delete_remote_branch)
      allow(git_vcs_client).to receive(:server_availability?).and_return(server_availability)
    end

    subject { git_vcs_actions.land_changes "origin", "master", "develop" }

    context "when the server is unavailable" do
      let(:server_availability) { false }
      let(:uncommitted_changes) { [] }

      it "exits the application" do
        expect(logger).to receive(:ftl)
          .with("Couldn't land changes - Remote 'origin' unavailable")
        expect { subject }.to raise_error SystemExit
      end
    end

    context "when there are uncommitted changes" do
      let(:server_availability) { true }
      it "exits cx without pushing" do
        expect(git_vcs_client).to_not receive(:checkout)
        expect(git_vcs_client).to_not receive(:merge_fast_forward_only)
        expect(git_vcs_client).to_not receive(:push)
        expect(git_vcs_client).to_not receive(:delete_remote_branch)
        expect { subject }.to raise_error SystemExit
      end

      it "prints a list of uncommitted changes" do
        expect(logger).to receive(:ftl).with(uncommitted_changes_output)
        expect { subject }.to raise_error SystemExit
      end
    end

    context "when the server is available" do
      let(:server_availability) { true }
      let(:uncommitted_changes) { [] }
      let(:options) { { hold: false } }

      before { allow(git_vcs_actions).to receive(:options).and_return(options) }

      context "given the hold argument is false" do
        before { subject }

        it "checks out and merges the feature branch into master" do
          expect(git_vcs_client).to have_received(:checkout).with("master")
          expect(git_vcs_client).to have_received(:merge_fast_forward_only).with("develop")
        end

        it "pushes the changes onto the main branch" do
          expect(git_vcs_client).to have_received(:push).with("origin", "master")
        end

        it "deletes the feature branch" do
          expect(git_vcs_client).to have_received(:delete_remote_branch).with("origin", "develop")
        end
      end

      context "given the hold argument" do
        let(:options) { { hold: true } }

        it "checks out and merges the feature branch into master" do
          expect(git_vcs_client).to receive(:checkout).with("master")
          expect(git_vcs_client).to receive(:merge_fast_forward_only).with("develop")
          expect { subject }.to raise_error SystemExit
        end

        it "doesn't pushes the changes onto the main branch" do
          expect(git_vcs_client).to_not receive(:push).with("origin", "master")
          expect { subject }.to raise_error SystemExit
        end

        it "doesn't deletes the feature branch" do
          expect(git_vcs_client).to_not receive(:delete_remote_branch).with("origin", "master")
          expect { subject }.to raise_error SystemExit
        end

        it "writes a n explanation for holding changes" do
          expect(logger).to receive(:inf).with("Changes have been held from being pushed to the"\
                                                  " remote and need to be pushed manually")
          expect { subject }.to raise_error SystemExit
        end
      end
    end
  end
end
