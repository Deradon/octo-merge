require 'inquirer'

module OctoMerge
  # TODO: Write specs
  class InteractivePullRequests
    def initialize(repo:, query:)
      @repo = repo
      @query = query
    end

    def self.get(options = {})
      new(repo: options[:repo], query: options[:query]).pull_requests
    end

    def pull_requests
      prs = list.all

      formatted_prs = prs.map do |pull_request|
        format_pull_request(pull_request)
      end

      system("clear")
      idx = Ask.checkbox "Select the pull requests you want to merge", formatted_prs

      idx.zip(prs).select { |e| e[0] }.map { |e| e[1][:number] }.join(",")
    end

    private

    attr_reader :repo, :query

    def display_pull_requests
      puts "[INFO] Fetching PullRequests. Please wait ...\n\n"

      list.all.each do |pull_request|
        puts format_pull_request(pull_request)
      end
    end

    def display_input_message
      puts "\n\nPlease enter the pull requests you want to merge: (e.g.: '23,42,66'):\n\n"
      print "$: "
    end

    def format_pull_request(pull_request)
      "#{pull_request.number}: \"#{pull_request.title}\" by @#{pull_request.user.login}"
    end

    def list
      @list = OctoMerge::ListPullRequests.new(repo: repo, query: query)
    end
  end
end

