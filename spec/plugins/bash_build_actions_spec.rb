require "rspec"
require_relative "../../lib/plugins/bash_build_actions"

describe BashBuildActions::Bash do
  let(:formatter) { true }
  let(:bash) { BashBuildActions::Bash.new formatter, nil, nil }

  before do
    allow(formatter).to receive(:inf)
    allow(formatter).to receive(:err)
  end

  describe "#cmd" do
    context "given messages to STDOUT and STDERR" do
      subject do
        bash.cmd "echo 'Message1 to stdout'; echo 'Message2 to stdout';
                  >&2 echo 'Message1 to stderr'; >&2 echo 'Message2 to stderr'"
      end

      it "writes STDOUT, STDERR in result object" do
        result = subject
        expect(result.stdout).to eq(["Message1 to stdout", "Message2 to stdout"])
        expect(result.stderr).to eq(["Message1 to stderr", "Message2 to stderr"])
      end

      it "writes to the formatter" do
        subject
        expect(formatter).to have_received(:inf).with("Message1 to stdout")
        expect(formatter).to have_received(:inf).with("Message2 to stdout")
        expect(formatter).to have_received(:err).with("Message1 to stderr")
        expect(formatter).to have_received(:err).with("Message2 to stderr")
      end
    end
  end
end
