require 'rails_helper'

describe Token, type: :model do
  let(:token_text) { "Bearer FOO" }

  before do
    @old_value = ENV[Token::ENVIRONMENT_KEY]
    ENV[Token::ENVIRONMENT_KEY] = token_text
  end

  after do
    ENV[Token::ENVIRONMENT_KEY] = @old_value
  end

  describe "instantiation" do
    subject do
      described_class.new token_text
    end

    context 'with a good value' do
      it { is_expected.to be_a Token }
    end

    context "when the authentication type is missing" do
      let(:token_text) { "FOO" }

      it "raises an error" do
        expect{ subject }.to raise_error(ArgumentError, /Bearer authentication/)
      end
    end

    context "when the authentication type is not 'Bearer'" do
      let(:token_text) { "Token FOO" }

      it "raises an error" do
        expect{ subject }.to raise_error(ArgumentError, /Bearer authentication/)
      end
    end
  end

  describe "#valid?" do
    subject do
      described_class.new(token_text).valid?
    end

    context "with a matching token" do
      it { is_expected.to eq false}
    end

    context "with a non-matching token" do
      let(:token_text) { "Bearer this_does_not_match" }
      it { is_expected.to eq false}
    end

  end
end