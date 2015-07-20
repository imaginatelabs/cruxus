require "fileutils"
require "securerandom"
require_relative "conf_dir_helper"

# Utility to manage various directory functions
module FileHelper
  def temp_dir(folder = SecureRandom.uuid)
    path = "/tmp/cx/#{folder}"
    FileUtils.mkdir_p path
    path
  end

  def files(dirname, glob = "**/*")
    files = []
    ConfDirHelper.get_conf_paths(dirname).each do |dir|
      find = "#{dir}#{glob}"
      files << Dir.glob(find).select { |f| File.file?(f) } if Dir.exist?(dir)
    end
    files.flatten.map { |f| File.absolute_path(f) }
  end
end

include FileHelper
