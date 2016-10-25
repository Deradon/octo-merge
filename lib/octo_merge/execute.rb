module OctoMerge
  class Execute
    attr_reader :context, :strategy, :remote, :base_branch

    # TODO: move `remote` into context
    def initialize(context:, strategy:, remote:, base_branch:)
      @context = context
      @strategy = strategy
      @remote = remote
      @base_branch = base_branch
    end

    def run
      env.run
    end

    def env
      @env ||= strategy.new(
        working_directory: context.working_directory,
        pull_requests: context.pull_requests,
        remote: remote,
        base_branch: base_branch
      )
    end
  end
end
