require 'optparse'

module OctoMerge
  class CLI
    class Parser
      def self.parse(args)
        new(args).parse!
      end

      def initialize(args)
        @args = args
      end

      def parse!
        prepare
        opts.parse!(args)
        options
      end

      private

      attr_reader :args

      def prepare
        prepare_banner

        prepare_application

        opts.separator ""
        opts.separator "Common options:"

        prepare_help
        prepare_version
      end

      def prepare_banner
        opts.banner = "Usage: octo-merge [options]"
        opts.separator ""
      end

      def prepare_application
        opts.on("--repo=REPO", "Repository (e.g.: 'rails/rails')") do |repo|
          options[:repo] = repo
        end

        # TODO: Description && default
        opts.on("--remote=remote", "Remote (e.g.: 'upstream')") do |remote|
          options[:remote] = remote
        end

        # TODO: Description && default
        opts.on("--base_branch=base_branch", "Base branch (e.g.: 'master')") do |base_branch|
          options[:base_branch] = base_branch
        end

        opts.on("--dir=DIR", "Working directory (e.g.: '~/Dev/Rails/rails')") do |dir|
          options[:dir] = dir
        end

        opts.on("--pull_requests=PULL_REQUESTS", "Pull requests (e.g.: '23,42,66')") do |pull_requests|
          options[:pull_requests] = pull_requests
        end

        opts.on("--login=login", "Login (Your GitHub username)") do |login|
          options[:login] = login
        end

        opts.on("--password=password", "Password (Your GitHub API-Token)") do |password|
          options[:password] = password
        end

        opts.on("--strategy=STRATEGY", "Merge strategy (e.g.: 'MergeWithoutRebase')") do |strategy|
          options[:strategy] = strategy
        end

        opts.on("--query=QUERY", "Query to use in interactive mode (e.g.: 'label:ready-to-merge')") do |query|
          options[:query] = query
        end

        opts.on('--interactive', 'Select PullRequests within an interactive session') do |interactive|
          options[:interactive] = interactive
        end

        opts.on('--setup', 'Setup') do |setup|
          options[:setup] = setup
        end
      end

      def prepare_help
        opts.on_tail('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
      end

      def prepare_version
        opts.on_tail('-v', '--version', 'Display the version') do
          puts OctoMerge::VERSION
          exit
        end
      end

      def opts
        @opts ||= OptionParser.new
      end

      def options
        @options ||= {}
      end
    end
  end
end
