module OctoMerge
  module Strategy
    class MergeWithRebase < Base
      def run
        fetch_base_branch

        pull_requests.each do |pull_request|
          fetch(pull_request)

          git.checkout(pull_request.number_branch)
          git.rebase(base_branch)

          git.checkout(base_branch)
          merge(pull_request)

          git.delete_branch(pull_request.number_branch)
        end
      end

      private

      def merge(pull_request)
        message = "Merge branch '#{pull_request.remote_branch}'"

        git.merge_no_ff("-m \"#{message}\" #{pull_request.number_branch}")
      end
    end
  end
end
