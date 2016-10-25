require "spec_helper"

describe OctoMerge::CLI do
  subject(:cli) { described_class.new(args) }

  let(:args) { [] }
  let(:options) {
    instance_double(OctoMerge::Options,
      login: "me",
      password: "42",
      base_branch: "production",
      dir: "rails",
      pull_requests: "23,42",
      repo: "rails",
      remote: "upstream",
      strategy: "simple",
      setup: false
    )
  }

  around do |example|
    login = OctoMerge.configuration.login
    password = OctoMerge.configuration.password

    example.run

    OctoMerge.configuration.login = login
    OctoMerge.configuration.password = password
  end

  describe "#run" do
    before do
      allow(OctoMerge).to receive(:run).and_return(false)
      allow(OctoMerge::CLI::Parser).to receive(:parse).and_return({})
      allow(OctoMerge::Options).to receive(:new).and_return(options)
      allow(options).to receive("cli_options=").and_return({})
    end

    it "updates the configuration" do
      cli.run
      expect(OctoMerge.configuration.login).to eq("me")
      expect(OctoMerge.configuration.password).to eq("42")
    end

    it "calls OctoMerge.run" do
      expect(OctoMerge).to receive(:run).with(
        base_branch: "production",
        pull_request_numbers: "23,42",
        repo: "rails",
        remote: "upstream",
        strategy: "simple",
        working_directory: "rails"
      ).and_return(true)
      cli.run
    end

    context "with setup set in options" do
      let(:options) {
        instance_double(OctoMerge::Options,
          login: "me",
          password: "42",
          setup: true
        )
      }

      it "calls OctoMerge::Setup.run" do
        expect(OctoMerge::Setup).to receive(:run).with(options).and_return(true)
        cli.run
      end
    end
  end
end
