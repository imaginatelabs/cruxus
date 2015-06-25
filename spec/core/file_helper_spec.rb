require "rspec"
require_relative "../../lib/core/helpers/file_helper"

describe FileHelper do
  let(:file_helper) { FileHelper }

  describe "#temp_dir" do
    before do
      allow(SecureRandom).to receive(:uuid).and_return("61a5ad24-9f70-4693-bc59-76333de04bbb")
      allow(FileUtils).to receive(:mkdir_p)
    end

    context "given no argument" do
      subject { file_helper.temp_dir }

      it "returns a temp directory with uuid" do
        is_expected.to eq("/tmp/cx/61a5ad24-9f70-4693-bc59-76333de04bbb")
      end
    end

    context "given an argument for a folder" do
      subject { file_helper.temp_dir "foo" }

      it "returns a temp directory with the given folder" do
        is_expected.to eq("/tmp/cx/foo")
      end
    end
  end

  describe "#files" do
    let(:conf_dir_helper) { ConfDirHelper }

    before do
      allow(ConfDirHelper).to receive(:get_cxconf_paths)
        .with("plugins/")
        .and_return(%W(#{File.dirname(__FILE__)}/plugins/))
    end

    context "when given an exiting directory" do
      subject { file_helper.files("plugins/").to_s }

      context "using the default glob to match" do
        it "return all files in the directory" do
          expect(subject).to include("my_plugin_test.rb",
                                     "my_plugin2_test.rb",
                                     "unrelated_file.rb")
        end
      end

      context "when give a custom glob to match" do
        subject { file_helper.files("plugins/", "**/*plugin2*").to_s }

        it "returns only the matching files" do
          expect(subject).to include("my_plugin2_test.rb")
        end
      end
    end
  end
end
