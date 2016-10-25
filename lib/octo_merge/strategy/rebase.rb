module OctoMerge
  module Strategy
    class Rebase < Base
      def run
        fetch_base_branch

        pull_requests.each do |pull_request|
          fetch(pull_request)

          git.checkout(pull_request.number_branch)
          git.rebase(base_branch)

          git.checkout(base_branch)
          git.rebase("#{pull_request.number_branch}")

          git.delete_branch(pull_request.number_branch)
        end
      end
    end
  end
end
