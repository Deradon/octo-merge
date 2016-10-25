module SetupExampleRepos
  def self.included(base)
    base.instance_eval do
      subject(:history) { mallory.history }

      let(:upstream) { SimpleGit.new(name: "upstream") }
      let(:mallory) { SimpleGit.new(name: "mallory") }

      let(:working_directory) { mallory.path }
      let(:alice_cowboy_hat) {
        instance_double(
          OctoMerge::PullRequest,
          remote: "alice",
          remote_branch: "cowboy_hat",
          number_branch: "pull/23",
          url: "example.com/23",
          title: "Adds cowboy hat",
          body: ""
        )
      }
      let(:bob_sunglasses) {
        instance_double(
          OctoMerge::PullRequest,
          remote: "bob",
          remote_branch: "sunglasses",
          number_branch: "pull/42",
          url: "example.com/42",
          title: "Adds sunglasses",
          body: "## Lorem ipsum\n\ndolor sit amet!"
        )
      }

      before { setup_example_repos }

      before do
        described_class.run(
          working_directory: working_directory,
          pull_requests: [alice_cowboy_hat, bob_sunglasses],
          remote: "upstream",
          base_branch: "master"
        )
      end
    end
  end

  def setup_example_repos
    SimpleGit.clear!

    upstream.create
    upstream.add_item("earrrings")
    upstream.checkout_branch("original-master")

    mallory.create
    mallory.add_remote("upstream")
    mallory.reset("upstream", "master")

    upstream.checkout("master")
    upstream.add_item("tattoo")
    upstream.add_item("piercing")

    upstream.checkout("original-master")
    upstream.checkout_branch("pull/23/head")
    upstream.add_item("cowboy_hat")

    upstream.checkout("original-master")
    upstream.checkout_branch("pull/42/head")
    upstream.add_item("sunglasses")
  end
end
