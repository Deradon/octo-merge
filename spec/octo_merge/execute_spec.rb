require 'spec_helper'

describe OctoMerge::Execute do
  subject(:execute) {
    described_class.new(
      context: context,
      strategy: strategy,
      remote: remote,
      base_branch: base_branch
    )
  }

  let(:context) {
    instance_double(
      OctoMerge::Context,
      working_directory: "foo/bar",
      pull_requests: [pull_request, another_pull_request]
    )
  }
  let(:strategy) { OctoMerge::Strategy::MergeWithoutRebase }
  let(:remote) { "upstream" }
  let(:base_branch) { "master" }

  let(:pull_request) { instance_double(OctoMerge::PullRequest) }
  let(:another_pull_request) { instance_double(OctoMerge::PullRequest) }

  its(:context) { is_expected.to eq(context) }
  its(:strategy) { is_expected.to eq(strategy) }

  describe "#env" do
    subject { execute.env }

    it { is_expected.to be_a(strategy) }
    its(:working_directory) { is_expected.to eq("foo/bar") }
    its(:pull_requests) { is_expected.to eq([pull_request, another_pull_request]) }
    its(:remote) { is_expected.to eq(remote) }
    its(:base_branch) { is_expected.to eq(base_branch) }
  end

  describe "#run" do
    let(:env) { instance_double(strategy) }

    before { allow(subject).to receive(:env).and_return(env) }
    after { execute.run }

    it "calls run on #env" do
      expect(env).to receive(:run)
    end
  end
end
