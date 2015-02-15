require "net/http"
require "json"
require "oga"
require "csv"

# Interface for making REST requests
module RestClient
  def get(uri, options = { as: :json })
    parse_raw_response(raw_get(uri), options[:as])
  end

  private

  REDIRECT_CODES = %w(301 302 303 307 308)

  def raw_get(uri)
    response  = Net::HTTP.get_response(URI.parse(uri))
    REDIRECT_CODES.include?(response.code) ? raw_get(response.header["location"]) : response.body
  rescue URI::InvalidURIError, TypeError => e
    raise(e.class, "'#{uri}' is not a valid URI", caller)
  rescue SocketError => e
    raise(e.class, "Can't connect to '#{uri}', check your connected to a network.", caller)
  end

  # rubocop:disable all
  def parse_raw_response(response, parse_option)
    case parse_option
    when :json
      return  JSON.parse response
    when :xml
      return Oga.parse_xml response
    when :html
      return Oga.parse_html response
    when :csv
      return CSV.parse response
    when :text
      return response
    else
      return response
    end
  end
  # rubocop:enable all
end

include RestClient
