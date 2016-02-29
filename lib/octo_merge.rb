require "octo_merge/version"

require "octo_merge/configuration"
require "octo_merge/context"
require "octo_merge/execute"
require "octo_merge/git"
require "octo_merge/pull_request"

require "octo_merge/abstract_merge"
require "octo_merge/merge_with_rebase"
require "octo_merge/merge_without_rebase"

module OctoMerge
  class << self
    def run(repo:, pull_request_numbers:, working_directory:, strategy:)
      context = Context.new(
        working_directory: working_directory,
        repo: repo,
        pull_request_numbers: pull_request_numbers
      )

      Execute.new(context: context, strategy: strategy).run
    end

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
