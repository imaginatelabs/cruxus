module MyPluginTest
  # A stub plugin for testing
  class MyPlugin
    attr_accessor :formatter, :options, :conf

    def initialize(formatter, options, conf)
      @formatter = formatter
      @options = options
      @conf = conf
    end

    def self.generate(formatter, options, conf)
      new formatter, options, conf
    end
  end
end
