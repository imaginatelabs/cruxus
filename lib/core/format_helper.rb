# Helps with formatting commands
module FormatHelper
  FMT = "%-8s %s"
  def fmt(name, args)
    format FMT, name, args
  end
end
