# == Links
#
# * https://www.atlassian.com/git/tutorials/merging-vs-rebasing/workflow-walkthrough
# * https://www.atlassian.com/git/articles/git-team-workflows-merge-or-rebase/
module OctoMerge
  module Strategy
    class Base
      attr_reader :working_directory, :pull_requests, :remote, :base_branch

      def initialize(working_directory:, pull_requests:, remote:, base_branch:)
        @working_directory = working_directory
        @pull_requests = pull_requests
        @remote = remote
        @base_branch = base_branch
      end

      def self.run(*args)
        new(*args).tap { |strategy| strategy.run }
      end

      def run
        fail NotImplementedError
      end

      private

      def git
        @git ||= Git.new(working_directory)
      end

      # Fetch the read-only branch for the corresponding pull request and
      # create a local branch to rebase the base branch on.
      #
      # Read more: [Checking out pull requests locally](https://help.github.com/articles/checking-out-pull-requests-locally/)
      def fetch(pull_request)
        git.fetch "#{remote} #{pull_request.number_branch}/head:#{pull_request.number_branch} --force"
      end

      def fetch_base_branch
        git.checkout(base_branch)
        git.fetch(remote)
        git.reset_hard("#{remote}/#{base_branch}")
      end
    end
  end
end
