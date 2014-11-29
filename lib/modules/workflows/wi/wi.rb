require 'bundler/vendored_thor'

module WiWorkflow

  class Wi < Thor

    def self.help_desc
      'Manage CX Work Items'
    end

    desc 'new', 'Create new work item'
    def new
      puts("I'm in your work item")
    end

  end

end