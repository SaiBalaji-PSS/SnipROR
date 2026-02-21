class Api::Auth::AuthController < ApplicationController
  def login
    render json: { message: "Login called" }, status: :ok
  end
  def signup
    render json: { message: "Sign up called" }, status: :ok
  end
end
