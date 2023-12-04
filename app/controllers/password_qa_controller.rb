class PasswordQaController < ApplicationController
  def check
    password = Password.new(password: check_params)

    if password.valid?
      render json: { passed_qa: true }, status: :ok
    else
      render json: { passed_qa: false, errors: password.errors }, status: :ok
    end
  end

  private

  def check_params
    params.require(:password)
  end
end
