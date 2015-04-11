require "open3"

# Manages interaction with the command line
module Cmd
  # Run a command and return the output
  def run(cmd)
    `#{cmd}`.strip
  end

  # TODO: Fully implement and test
  # Run a command and capture stdout stderr and exit status
  def run_std(cmd)
    o, e, r = Open3.capture3(cmd)
    { out: o, err: e, status: r }
  end

  # TODO: Fully implement and test
  # Run a command interactively
  def run_i(cmd)
    Process.wait(spawn(cmd))
  end

  # TODO: Fully implement and test
  # Prints the results for the stdout, stderr and result
  def put_std_res(result)
    failed = result[:status].exitstatus == 0
    cx_exit "exited with error status #{result[:status].exitstatus}" unless failed
    inf result[:out].strip
  end
end

include Cmd
