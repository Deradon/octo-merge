require 'spec_helper'

describe OctoMerge::CLI::Parser do
  subject(:parser) { described_class.new(args) }

  let(:args) {
    %w(
--login
me
--password
secret
--dir
myrails
--pull_requests
23,42
--query
label:pr
--repo
rails
--remote
upstream
--base_branch
production
--strategy
Simple
--interactive
    )
  }

  describe "#parse!" do
    subject { parser.parse! }
    after { subject }

    specify { expect(subject[:login]).to eq("me") }
    specify { expect(subject[:password]).to eq("secret") }

    specify { expect(subject[:base_branch]).to eq("production") }
    specify { expect(subject[:dir]).to eq("myrails") }
    specify { expect(subject[:pull_requests]).to eq("23,42") }
    specify { expect(subject[:query]).to eq("label:pr") }
    specify { expect(subject[:repo]).to eq("rails") }
    specify { expect(subject[:remote]).to eq("upstream") }
    specify { expect(subject[:strategy]).to eq("Simple") }

    specify { expect(subject[:interactive]).to eq(true) }
    specify { expect(subject[:setup]).to eq(nil) }

    context "with --help" do
      let(:args) { ["--help"] }

      it { expect(parser).to receive(:exit) }
    end

    context "with --version" do
      let(:args) { ["--version"] }

      it { expect(parser).to receive(:exit) }
    end

    context "with --setup" do
      let(:args) { ["--setup"] }

      specify { expect(subject[:setup]).to eq(true) }
    end
  end
end
