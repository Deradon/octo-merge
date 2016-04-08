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
        setup
        opts.parse!(args)
        options
      end

      private

      attr_reader :args

      def setup
        setup_banner

        setup_application

        opts.separator ""
        opts.separator "Common options:"

        setup_help
        setup_version
      end

      def setup_banner
        opts.banner = "Usage: octo-merge [options]"
        opts.separator ""
      end

      def setup_application
        opts.on("--repo=REPO", "Repository (e.g.: 'rails/rails')") do |repo|
          options[:repo] = repo
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
      end

      def setup_help
        opts.on_tail('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
      end

      def setup_version
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
