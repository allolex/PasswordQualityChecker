require 'rails_helper'

RSpec.describe "PasswordQA", type: :request do
  let(:valid_api_token) { "FOO" }
  let(:token_text) { "Bearer #{valid_api_token}" }

  let(:valid_headers) do
    { "HTTP_AUTHORIZATION" => token_text }
  end

  let(:valid_params) do
    { password: "bar" }
  end

  let(:response_body) { JSON.load response.body }

  before do
    @old_value = ENV[Token::ENVIRONMENT_KEY]
    ENV[Token::ENVIRONMENT_KEY] = valid_api_token
  end

  after do
    ENV[Token::ENVIRONMENT_KEY] = @old_value
  end

  describe "GET /password_qa" do
    context "with a valid payload" do
      let(:request_params) { valid_params }
      let(:request_headers) { valid_headers }

      let(:make_request) do
        post password_check_url, headers: request_headers, params: request_params
      end

      context "with a too-simple password" do
        it "returns :ok with passed_qa false and includes validation errors" do
          make_request
          expect(response).to have_http_status(:ok)
          expect(response_body["passed_qa"]).to eq false
          expect(response.body).to match /at least twelve characters/
          expect(response.body).to match /contain a symbol/
          expect(response.body).to match /contain a digit/
          expect(response.body).to match /contain an upper case letter/
          expect(response.body).to match /Uncommon words are better/
        end
      end

      context "with a too-simple password" do
        let(:request_params) { { password: "jkhsdljhdsSDDFSSF2344^^$$$" } }

        it "returns :ok with passed_qa false and includes validation errors" do
          make_request
          expect(response).to have_http_status(:ok)
          expect(response_body["passed_qa"]).to eq true
        end
      end
    end
  end
end

