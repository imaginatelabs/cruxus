require "rspec"
require_relative "../../lib/plugins/plain_formatter"

describe PlainFormatter::Plain do
  subject do
    PlainFormatter::Plain.new("test_plugin", log_level: log_level)
  end

  context "given the default settings" do
    let(:log_level) { "info" }

    it "PlainFormatter is initialized correctly" do
      expect(subject.info?).to be(true)
    end
  end
end
