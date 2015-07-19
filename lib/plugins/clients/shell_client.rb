require "open3"
require "ostruct"

# Manages interaction with the command line
module ShellClient
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize:
  def run(cmd, &_block)
    result = OpenStruct.new stdout: [], stderr: [], stdin: []
    threads = []

    Open3.popen3(cmd) do |stdin, stdout, stderr, thread|
      threads << Thread.new do
        until (line_out = stdout.gets).nil?
          line_out = line_out.strip # strip! causes race conditions
          result[:stdout] << line_out
          yield line_out, nil, thread if block_given?
        end
      end

      threads << Thread.new do
        until (line_err = stderr.gets).nil?
          line_err = line_err.strip # strip! causes race conditions
          result[:stderr] << line_err
          yield nil, line_err, thread  if block_given?
        end
      end

      # STDIN thread will be killed not joined
      Thread.new do
        while thread.alive?
          line_in = $stdin.gets
          result[:stdin] << line_in.strip
          stdin.puts line_in
        end
      end

      threads << thread
      threads.each(&:join)

      result[:exitstatus] = thread.value.exitstatus
      result[:pid] = thread.value.pid
      result[:success?] = thread.value.success?
    end
    result
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize:
end

include ShellClient
