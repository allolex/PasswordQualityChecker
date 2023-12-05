class ApplicationController < ActionController::Base
  rescue_from ArgumentError do |err|
    render json: { errors: [err.message] }, status: :bad_request
  end

  before_action :require_token, unless: :skip_token_check?

  private

  def skip_token_check?
    single_page_app_origins.include? request.headers.fetch("HTTP_ORIGIN")
  end

  def single_page_app_origins
    [ENV.fetch("SPA_ORIGIN")]
  end

  def require_token
    token = Token.new(request.headers["HTTP_AUTHORIZATION"])
    head :forbidden unless token && token.valid?
  end
end
