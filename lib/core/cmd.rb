require "open3"
require "ostruct"

# Manages interaction with the command line
module Cmd
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize:
  def run(cmd, &_block)
    stdout_a, stderr_a, stdin_a, result = [], [], [], {}

    Open3.popen3(cmd) do |stdin, stdout, stderr, thread|
      Thread.new do
        until (line = stdout.gets).nil?
          stdout_a << line.strip!
          yield line, nil, thread if block_given?
        end
      end

      Thread.new do
        until (line = stderr.gets).nil?
          stderr_a << line.strip!
          yield nil, line, thread  if block_given?
        end
      end

      Thread.new do
        while thread.alive?
          line_in = $stdin.gets
          stdin_a << line_in.strip!
          stdin.puts line_in
        end
      end

      thread.join

      result = {
        stdout: stdout_a, stderr: stderr_a, stdin: stdin_a,
        exitstatus: thread.value.exitstatus,
        pid: thread.value.pid,
        success?: thread.value.success?
      }
    end
    OpenStruct.new result
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize:
end

include Cmd
