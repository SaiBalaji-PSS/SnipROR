class Api::Auth::AuthController < ApplicationController
  skip_before_action :check_authorization, only: [ :login, :signup ]
  def login
    matched_user = User.find_by({ email: auth_params[:email] })
    if matched_user.nil?
      render json: { message: "The user with given email not found" }, status: :ok
    else
      if matched_user.authenticate(auth_params[:password])
        generated_token = JwtHandler.encode_jwt_token({ user_id: matched_user.user_id })
        render json: { message: "Login success", token: generated_token }, status: :ok

      else
        render json: { message: "Invalid password" }, status: :ok
      end
    end
  end
  def signup
    user = User.new(auth_params)
    puts user
    if user.save
      render json: { message: "Account created successfully" }, status: :ok
    else
      render json: { message: user.errors.full_messages.to_sentence }, status: :ok
    end
  end

  def me
    render json: { user: current_user }
  end

  def delete_user
    if current_user.destroy
      render json:{message: "Account deleted successfully"}, status: :ok
    else
      render json:{message: "Unable to delete the account"}, status: :ok
    end
  end

  private
  def auth_params
    params.permit(:email, :password, :user_name)
  end
end
