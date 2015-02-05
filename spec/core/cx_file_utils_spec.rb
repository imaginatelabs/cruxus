require "rspec"
require_relative "../../lib/core/cx_file_utils"

describe CxFileUtils do
  let(:dir_utils) { CxFileUtils }

  describe "#temp_dir" do
    before do
      allow(SecureRandom).to receive(:uuid).and_return("61a5ad24-9f70-4693-bc59-76333de04bbb")
      allow(FileUtils).to receive(:mkdir_p)
    end

    context "given no argument" do
      subject { dir_utils.temp_dir }

      it "returns a temp directory with uuid" do
        is_expected.to eq("/tmp/cx/61a5ad24-9f70-4693-bc59-76333de04bbb")
      end
    end

    context "given an argument for a folder" do
      subject { dir_utils.temp_dir "foo" }

      it "returns a temp directory with the given folder" do
        is_expected.to eq("/tmp/cx/foo")
      end
    end
  end
end
