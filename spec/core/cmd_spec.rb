require "rspec"
require_relative "../../lib/core/shell"

describe Shell do
  describe ".run" do
    let(:cmd) { Shell }
    subject { cmd.run bash_cmd }

    context "given the bash command 'echo'" do
      let(:bash_cmd) { "echo 'Hello World'" }

      it "prints 'Hello World' to STDOUT" do
        expect(subject[:stdout][0]).to eq("Hello World")
      end
    end

    context "given a bash script" do
      let(:bash_cmd) { File.absolute_path "./spec/scripts/bash_build_actions_script.sh" }
      let(:result) { nil }

      before do
        allow($stdin).to receive(:gets).once.and_return("Hello\n", "You\n", "99\n")
      end

      it "Correctly handles stdout" do
        expect(subject.stdout).to eq(["Message to stdout", "Type a greeting",
                                      "Type your name", "Hello You", "Type an exitcode",
                                      "Program exiting with exitcode 99"])
      end

      it "Correctly handles stderr" do
        expect(subject.stderr).to eq(["Message to stderr"])
      end

      it "Correctly handles stdin" do
        expect(subject.stdin).to eq(%w(Hello You 99))
      end

      it "Correctly handles successful exitstatus" do
        allow($stdin).to receive(:gets).once.and_return("Hello\n", "You\n", "0\n")
        result = subject
        expect(result.exitstatus).to eq(0)
        expect(result.success?).to eq(true)
      end

      it "Correctly handles failed exitstatus" do
        result = subject
        expect(result.exitstatus).to eq(99)
        expect(result.success?).to eq(false)
      end

      it "Correctly records PID" do
        expect(subject.pid).to be_a_kind_of Numeric
      end
    end
  end
end
