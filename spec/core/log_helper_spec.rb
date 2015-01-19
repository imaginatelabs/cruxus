require "rspec"
require "confstruct"
require "logger"
require_relative "../../lib/core/log_helper"

describe LogHelper do
  describe "#log_file_path" do
    subject { LogHelper.log_file_path(file) }

    context "given a non nil value for file path" do
      let(:file) { "/my_log_file.log" }

      it "returns the provided log file path" do
        expect(subject).to eq("/my_log_file.log")
      end
    end

    context "given a 'nil' value for file path" do
      let(:file) { nil }

      it "returns the log file path form configuration" do
        expect(subject).to eq(false)
      end
    end

    context "given the value 'file' for file path" do
      let(:file) { "log_file" }

      it "returns the log file path form configuration" do
        expect(subject).to eq("cruxus.log")
      end
    end

    context "given the value 'false' for file path" do
      let(:file) { false }

      it "returns false" do
        expect(subject).to eq(false)
      end
    end
  end

  describe "#parse_log_level" do
    subject { LogHelper.parse_log_level(level) }

    context "given a full downcase log level" do
      let(:level) { "debug" }

      it "returns the full log level value" do
        expect(subject).to eq(Logger::Severity::DEBUG)
      end
    end

    context "given a full upcase log level" do
      let(:level) { "DEBUG" }

      it "returns the full log level value" do
        expect(subject).to eq(Logger::Severity::DEBUG)
      end
    end

    context "given a partial log level" do
      let(:level) { "deb" }

      it "returns the full log level value" do
        expect(subject).to eq(Logger::Severity::DEBUG)
      end
    end

    context "given a single char log level" do
      let(:level) { "d" }

      it "returns the full log level value" do
        expect(subject).to eq(Logger::Severity::DEBUG)
      end
    end

    context "given a non existent log level" do
      let(:level) { "foo" }

      it "returns the default log level value" do
        expect(subject).to eq(Logger::Severity::INFO)
      end
    end
  end

  describe "#output_format" do
    subject { LogHelper.output_format(log_file) }

    context "given a non nil value for the log file path" do
      let(:log_file) { "not null" }

      it "returns the log file message format" do
        # rubocop:disable all
        expect(subject).to eq('#{severity_id}, [#{datetime.iso8601}##{pid}] #{severity_label} -- #{plugin_name}: #{msg}')
        # rubocop:enable all
      end
    end

    context "given a false value for the log file path" do
      let(:log_file) { false }

      it "returns the log std message format" do
        # rubocop:disable all
        expect(subject).to eq('#{msg}')
        # rubocop:enable all
      end
    end

    context "given a nil value for the log file path" do
      let(:log_file) { nil }

      it "returns the log std message format" do
        # rubocop:disable all
        expect(subject).to eq('#{msg}')
        # rubocop:enable all
      end
    end
  end

  # rubocop:disable all
  describe "#output_formatter" do
    subject do
      LogHelper.output_formatter(format, plugin_name)
          .call(severity,datetime,progname,msg)
    end

    msg = "the message"
    severity = "info"
    severity_label = "info"
    severity_id = "i"
    pid = "1234"
    datetime = DateTime.new(2001, 2, 3, 4, 5, 6)
    progname = "test-progname"
    plugin_name = "test_plugin_name"

    let(:msg) { msg }
    let(:severity) { severity }
    let(:datetime) { datetime }
    let(:progname) { progname }
    let(:plugin_name) { plugin_name }

    before do
      allow(Process).to receive(:pid).and_return(pid)
    end

    format_patterns = '#{msg}',
                      '#{plugin_name} #{msg}',
                      '#{severity_id}, [#{datetime.iso8601}##{pid}] #{severity_label} -- #{plugin_name}: #{msg}',
                      '',
                      nil

    format_patterns.each do |format_pattern|
      context "given the format '#{format_pattern}'" do
        let(:format) { format_pattern }

        it { expect(subject).to eq(eval('"' + format_pattern.to_s + '\n"')) }
      end
    end
  end
  # rubocop:enable all

  describe "#logger" do
    subject { LogHelper.logger(std, log_file, log_level, formatter) }

    let(:std) { STDOUT }
    let(:log_level) { Logger::Severity::INFO }
    let(:formatter) { true }

    LOG_FILE_NAME = "test.log"
    context "given a non nil log_file" do
      let(:log_file) { Logger.new(LOG_FILE_NAME) }

      it "returns the file based logger passed in" do
        expect(subject).to eq(log_file)
      end
    end

    context "given a non nil log_file" do
      let(:log_file) { nil }

      it "returns a new logger" do
        expect(subject.is_a? Logger).to eq(true)
      end
    end

    after do
      FileUtils.rm LOG_FILE_NAME, force: true
    end
  end
end
