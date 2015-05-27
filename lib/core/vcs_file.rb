# Represents version control details about a file
class VcsFile
  attr_reader :path, :status

  def initialize(path, status)
    @path = path
    @status = status
  end

  def to_s
    format "%-9s %-9s %s", @status[:staged], @status[:unstaged], @path
  end
end
