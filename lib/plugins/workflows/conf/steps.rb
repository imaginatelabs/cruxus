require_relative "../../../core/cxconf"

module ConfWorkflow
  # Manage configuration
  class Steps
    def initialize(conf = CxConf)
      @conf = conf
    end

    def select(query)
      query == "*" ? @conf.to_hash : recursive_search(query, @conf.to_hash)
    end

    def key(hkey)
      @conf["#{hkey}"]
    end

    private

    def recursive_search(query, hash)
      result = {}
      hash.each do |k, v|
        result[k] = v unless k.to_s.match(query).nil?
        if v.is_a?(Hash)
          result[k] = recursive_search(query, v)
        else
          result[k] = v unless v.to_s.match(query).nil?
        end
      end
      result.delete_if { |_, v| v == {} }
    end
  end
end
