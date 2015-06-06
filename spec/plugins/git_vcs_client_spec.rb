require "rspec"
require_relative "../../lib/plugins/git_vcs_client"

describe GitVcsClient::Git do
  let(:git) { GitVcsClient::Git.new }

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
