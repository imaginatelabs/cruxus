require "rspec"
require_relative "../../lib/plugins/clients/git_vcs_client"

describe GitVcsClient::Git do
  let(:git) { GitVcsClient::Git.new }

  describe "#uncommitted_changes" do
    before do
      allow(git).to receive(:git).with("status --porcelain").and_return(uncommited_changes_list)
    end

    subject { git.uncommitted_changes }

    context "when there are uncommited changes" do
      context "when there are unstaged changes" do
        let(:uncommited_changes_list) do
          "?? first.txt\n"\
          " M foo.txt\n"\
          " D shell_test.sh\n"\
          " C untracked"
        end

        it "returns an array of vcs_change files" do
          list = subject
          expect(list.size).to eq(4)
          expect(list[0].status).to eq(staged: :untracked, unstaged: :untracked)
          expect(File.basename(list[0].path)).to eq("first.txt")
          expect(list[1].status).to eq(staged: :none, unstaged: :modified)
          expect(File.basename(list[1].path)).to eq("foo.txt")
          expect(list[2].status).to eq(staged: :none, unstaged: :deleted)
          expect(File.basename(list[2].path)).to eq("shell_test.sh")
          expect(list[3].status).to eq(staged: :none, unstaged: :copied)
          expect(File.basename(list[3].path)).to eq("untracked")
        end
      end

      context "when there are staged changes" do
        let(:uncommited_changes_list) do
          "?? first.txt\n"\
          "M  foo.txt\n"\
          "D  shell_test.sh\n"\
          "C  untracked"
        end

        it "returns an array of vcs_change files" do
          list = subject
          expect(list.size).to eq(4)
          expect(list[0].status).to eq(staged: :untracked, unstaged: :untracked)
          expect(File.basename(list[0].path)).to eq("first.txt")
          expect(list[1].status).to eq(staged: :modified, unstaged: :none)
          expect(File.basename(list[1].path)).to eq("foo.txt")
          expect(list[2].status).to eq(staged: :deleted, unstaged: :none)
          expect(File.basename(list[2].path)).to eq("shell_test.sh")
          expect(list[3].status).to eq(staged: :copied, unstaged: :none)
          expect(File.basename(list[3].path)).to eq("untracked")
        end
      end

      context "when there a combination of staged and unstaged" do
        let(:uncommited_changes_list) do
          "?? first.txt\n"\
          "R  foo.txt\n"\
          "MD shell_test.sh\n"\
          " M untracked"
        end

        it "returns an array of vcs_change files" do
          list = subject
          expect(list.size).to eq(4)
          expect(list[0].status).to eq(staged: :untracked, unstaged: :untracked)
          expect(File.basename(list[0].path)).to eq("first.txt")
          expect(list[1].status).to eq(staged: :renamed, unstaged: :none)
          expect(File.basename(list[1].path)).to eq("foo.txt")
          expect(list[2].status).to eq(staged: :modified, unstaged: :deleted)
          expect(File.basename(list[2].path)).to eq("shell_test.sh")
          expect(list[3].status).to eq(staged: :none, unstaged: :modified)
          expect(File.basename(list[3].path)).to eq("untracked")
        end
      end
    end

    context "when there are no changes" do
      let(:uncommited_changes_list) { "" }

      it "returns empty array" do
        expect(subject.size).to eq(0)
      end
    end
  end

  describe "#push" do
    before do
      allow(git).to receive(:git)
      subject
    end

    context "given default values" do
      subject { git.push "origin", "my_branch"  }

      it "pushes to the origin using the same branch names" do
        expect(git).to have_received(:git).with("push origin my_branch:my_branch")
      end
    end

    context "given a remote branch" do
      subject { git.push "origin", "my_branch", "remote_branch"  }

      it "pushes to the origin using the local and remote branch" do
        expect(git).to have_received(:git).with("push origin my_branch:remote_branch")
      end
    end
  end

  describe "#pull" do
    before do
      allow(git).to receive(:git)
      subject
    end

    context "given default values" do
      subject { git.pull "origin", "my_branch"  }

      it "pulls from the origin using the same branch names" do
        expect(git).to have_received(:git).with("pull origin my_branch:my_branch")
      end
    end

    context "given a remote branch" do
      subject { git.pull "origin", "my_branch", "remote_branch"  }

      it "pulls from the origin using the local and remote branch" do
        expect(git).to have_received(:git).with("pull origin my_branch:remote_branch")
      end
    end
  end
end
