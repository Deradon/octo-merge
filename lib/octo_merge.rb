require "octo_merge/version"

require "git"

require "octo_merge/cli"
require "octo_merge/configuration"
require "octo_merge/context"
require "octo_merge/execute"
require "octo_merge/interactive_pull_requests"
require "octo_merge/list_pull_requests"
require "octo_merge/options"
require "octo_merge/pull_request"
require "octo_merge/setup"
require "octo_merge/strategy"

module OctoMerge
  class << self
    def run(repo:,
            remote:,
            base_branch:,
            pull_request_numbers:,
            working_directory:,
            strategy:)

      context = Context.new(
        working_directory: working_directory,
        repo: repo,
        pull_request_numbers: pull_request_numbers
      )

      Execute.new(
        context: context,
        strategy: strategy,
        remote: remote,
        base_branch: base_branch
      ).run
    end

    def configure
      @github_client = nil
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def github_client
      @github_client ||= Octokit::Client.new(
        login: configuration.login,
        password: configuration.password
      )
    end
  end
end
