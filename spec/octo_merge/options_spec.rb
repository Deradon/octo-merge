require "spec_helper"

describe OctoMerge::Options do
  subject(:options) { described_class.new }

  let(:user_options_present) { false }
  let(:project_options_present) { false }

  before do
    allow(File).to receive(:exist?)
      .with(File.expand_path("~/.octo-merge.yml"))
      .and_return(user_options_present)

    allow(File).to receive(:exist?)
      .with(".octo-merge.yml")
      .and_return(project_options_present)
  end

  context "without user_options and project_options" do
    let(:user_options_present) { false }
    let(:project_options_present) { false }

    its(:login) { is_expected.to eq(nil) }
    its(:password) { is_expected.to eq(nil) }

    its(:base_branch) { is_expected.to eq("master") }
    its(:dir) { is_expected.to eq(File.expand_path(".")) }
    its(:pull_requests) { is_expected.to eq([]) }
    its(:repo) { is_expected.to eq(nil) }
    its(:remote) { is_expected.to eq('origin') }
    its(:strategy) { is_expected.to eq(OctoMerge::Strategy::MergeWithoutRebase) }
  end

  context "with user options" do
    let(:user_options_present) { true }

    before do
      allow(File).to receive(:read).with(File.expand_path("~/.octo-merge.yml"))
        .and_return(<<-YML
login: Deradon
password: geheim
strategy: Rebase
YML
)
    end

    its(:login) { is_expected.to eq("Deradon") }
    its(:password) { is_expected.to eq("geheim") }

    its(:dir) { is_expected.to eq(File.expand_path(".")) }
    its(:pull_requests) { is_expected.to eq([]) }
    its(:repo) { is_expected.to eq(nil) }
    its(:strategy) { is_expected.to eq(OctoMerge::Strategy::Rebase) }

    context "and with project options" do
      let(:project_options_present) { true }

      before do
        allow(File).to receive(:read).with(".octo-merge.yml")
          .and_return(<<-YML
repo: rails/rails
remote: upstream
base_branch: production
strategy: MergeWithoutRebase
YML
          )
      end

      its(:login) { is_expected.to eq("Deradon") }
      its(:password) { is_expected.to eq("geheim") }

      its(:base_branch) { is_expected.to eq("production") }
      its(:dir) { is_expected.to eq(File.expand_path(".")) }
      its(:pull_requests) { is_expected.to eq([]) }
      its(:repo) { is_expected.to eq("rails/rails") }
      its(:remote) { is_expected.to eq("upstream") }
      its(:strategy) { is_expected.to eq(OctoMerge::Strategy::MergeWithoutRebase) }

      context "and with cli options" do
        before do
          subject.cli_options = { pull_requests: "23,42" }
        end

        its(:login) { is_expected.to eq("Deradon") }
        its(:password) { is_expected.to eq("geheim") }

        its(:dir) { is_expected.to eq(File.expand_path(".")) }
        its(:pull_requests) { is_expected.to eq(["23", "42"]) }
        its(:repo) { is_expected.to eq("rails/rails") }
        its(:setup) { is_expected.to be(nil) }
        its(:strategy) { is_expected.to eq(OctoMerge::Strategy::MergeWithoutRebase) }

        context "when setup is given" do
          before do
            subject.cli_options = { setup: true }
          end

          its(:setup) { is_expected.to be(true) }
        end
      end
    end
  end
end
