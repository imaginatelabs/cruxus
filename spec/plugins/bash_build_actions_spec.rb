require "rspec"
require_relative "../../lib/plugins/bash_build_actions"

describe BashBuildActions::Bash do
  let(:logger) { true }
  let(:bash) { BashBuildActions::Bash.new logger, nil, nil }

  before do
    allow(logger).to receive(:inf)
    allow(logger).to receive(:err)
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

      it "writes to the logger" do
        subject
        expect(logger).to have_received(:inf).with("Message1 to stdout")
        expect(logger).to have_received(:inf).with("Message2 to stdout")
        expect(logger).to have_received(:err).with("Message1 to stderr")
        expect(logger).to have_received(:err).with("Message2 to stderr")
      end
    end

    context "given a passing exitstatus" do
      subject { bash.cmd "exit 0" }

      it "exits successfully" do
        expect(subject.exitstatus).to eq(0)
      end
    end

    context "given a failing exitstatus" do
      subject { bash.cmd "exit 1" }

      it "exits with failure exitstatus and logs message" do
        begin
          subject
        rescue SystemExit => e
          expect(e.status).to eq(1)
        end
      end
    end
  end
end
