class ApplicationController < ActionController::API
  before_action :check_authorization
  attr_accessor :current_user
  def check_authorization
    begin
    auth_header_value = request.headers["Authorization"]
    bearer_token = auth_header_value.split(" ")[1] if auth_header_value
    decoded_token = JwtHandler.decode_jwt_token(bearer_token)
    puts decoded_token
    @current_user = User.find(decoded_token[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: "User not found"}, status: :ok
    rescue  JWT::DecodeError
      render json: {message: "Unable to decode the token"}, status: :ok
    rescue JWT::ExpiredSignature
      render json: {message: "The token has expired"}, status: :ok
    rescue => e
      render json: {message: e.message}, status: :ok
    end
  end


end
