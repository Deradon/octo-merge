require 'spec_helper'

describe OctoMerge do
  let(:context) { instance_double(OctoMerge::Context) }
  let(:execute) { instance_double(OctoMerge::Execute, run: true) }

  it 'has a version number' do
    expect(OctoMerge::VERSION).not_to be nil
  end

  describe ".run" do
    after do
      OctoMerge.run(
        repo: "rails/rails",
        remote: "upstream",
        pull_request_numbers: [23, 42],
        working_directory: "foo/bar",
        base_branch: "master",
        strategy: OctoMerge::Strategy::MergeWithoutRebase
      )
    end

    specify do
      expect(OctoMerge::Context).to receive(:new)
        .with(
          working_directory: "foo/bar",
          repo: "rails/rails",
          pull_request_numbers: [23, 42]
        )
        .and_return(context)

      expect(OctoMerge::Execute).to receive(:new)
        .with(
          context: context,
          strategy: OctoMerge::Strategy::MergeWithoutRebase,
          remote: "upstream",
          base_branch: "master"
        )
        .and_return(execute)

      expect(execute).to receive(:run)
    end
  end

  describe ".configuration" do
    subject { described_class.configuration }
    it { is_expected.to be_a(OctoMerge::Configuration) }
  end

  describe ".configure" do
    subject { described_class.configuration }

    around do |example|
      described_class.configure do |config|
        config.login = "foo"
        config.password = "secret"
      end

      example.run

      described_class.configure do |config|
        config.login = nil
        config.password = nil
      end
    end

    its(:login) { is_expected.to eq("foo") }
    its(:password) { is_expected.to eq("secret") }
  end

  describe ".github_client" do
    context "when configured with login credentials" do
      around do |example|
        OctoMerge.configure do |config|
          config.login = "foo"
          config.password = "secret"
        end

        example.run

        OctoMerge.configure do |config|
          config.login = nil
          config.password = nil
        end
      end

      specify {
        expect(Octokit::Client).to receive(:new).with(
          login: "foo",
          password: "secret"
        )
        subject.github_client
      }
    end
  end
end
