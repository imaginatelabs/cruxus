module MyPluginTest
  # A stub plugin for testing
  class MyPlugin
    attr_accessor :logger, :options, :conf

    def initialize(logger, options, conf)
      @logger = logger
      @options = options
      @conf = conf
    end

    def self.generate(logger, options, conf)
      new logger, options, conf
    end
  end
end
