# Helper functions for strings
module StringHelper
  def camelize(str, upcase_first = true)
    if upcase_first
      str = str.gsub(/^[a-z\d]*/) { $&.capitalize }
    else
      str = str.gsub(/^_/, "").gsub!(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
    end
    str.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{Regexp.last_match[2].capitalize}" }.gsub("/", "::")
  end
end

include StringHelper
