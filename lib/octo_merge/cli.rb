require "octo_merge/cli/parser"

module OctoMerge
  class CLI
    attr_reader :args

    def self.run(*args)
      new(*args).run
    end

    def initialize(args)
      @args = args
    end

    def run
      configure

      if options.setup
        setup
      else
        execute
      end
    end

    private

    def configure
      OctoMerge.configure do |config|
        config.login = options.login
        config.password = options.password
      end
    end

    def setup
      Setup.run(options)
    end

    def execute
      OctoMerge.run(
        base_branch: options.base_branch,
        pull_request_numbers: options.pull_requests,
        repo: options.repo,
        remote: options.remote,
        strategy: options.strategy,
        working_directory: options.dir
      )
    end

    def options
      @options ||= Options.new.tap do |options|
        options.cli_options = Parser.parse(args)
      end
    end
  end
end
