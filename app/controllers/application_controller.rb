class ApplicationController < ActionController::Base
  before_action :require_token

  private

  def require_token
    return if request.xhr?
    token = Token.new(request.headers["HTTP_AUTHORIZATION"])
    head :forbidden unless token && token.valid?
  end
end
