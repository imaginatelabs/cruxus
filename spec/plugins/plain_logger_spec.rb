require "rspec"
require_relative "../../lib/plugins/plain_logger"

describe PlainLogger::Plain do
  let(:log_level) { "info" }

  subject do
    PlainLogger::Plain.new("test_plugin", log_level: log_level, log_file: log_file)
  end

  context "given the default settings" do
    let(:log_file) { false }

    it "PlainLogger is initialized correctly" do
      expect(subject.inf?).to be(true)
    end
  end

  context "given a log file" do
    let(:log_file) { "test.log" }

    it "creates a log file" do
      subject
      expect(File.exist? log_file).to eq(true)
    end

    after do
      FileUtils.rm log_file, force: true
    end
  end
end
