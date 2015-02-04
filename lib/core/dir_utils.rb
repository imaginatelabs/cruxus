require "fileutils"
require "securerandom"

# Utility to manage various directory functions
module DirUtils
  def temp_dir(folder = SecureRandom.uuid)
    path = "/tmp/cx/#{folder}"
    FileUtils.mkdir_p path
    path
  end
end

include DirUtils
