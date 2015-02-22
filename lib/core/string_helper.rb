# Helper functions for strings
module StringHelper
  def camelize(str, uppercase_first_letter = true)
    if uppercase_first_letter
      str = str.sub(/^[a-z\d]*/) { $&.capitalize }
    else
      str = str.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
    end
    regex = /(?:_|(\/))([a-z\d]*)/
    str.gsub(regex) { "#{Regexp.last_match[2].capitalize}" }.gsub("/", "::")
  end
end

include StringHelper
