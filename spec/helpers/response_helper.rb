require "net/http"
require "oga"
require "csv"

# Helper to load response data structures
module ResponseHelper
  def json(response_file)
    JSON.parse(text(response_file))
  end

  def xml(response_file)
    Oga.parse_xml(text(response_file))
  end

  def html(response_file)
    Oga.parse_html(text(response_file))
  end

  def csv(response_file)
    CSV.parse(text(response_file))
  end

  def text(response_file)
    File.read("spec/responses/#{response_file}")
  end
end

include ResponseHelper
