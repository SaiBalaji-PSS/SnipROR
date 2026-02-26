class Api::Auth::AuthController < ApplicationController
  skip_before_action :check_authorization, only: [ :login, :signup, :refresh_access_token ]
  def login
    matched_user = User.find_by({ email: auth_params[:email] })
    if matched_user.nil?
      render json: { issuccess: false, message: "The user with given email not found" }, status: :ok
    else
      if matched_user.authenticate(auth_params[:password])
        exp = 24.hour.from_now
        ref_exp = 26.hour.from_now
        generated_token = JwtHandler.encode_jwt_token({ user_id: matched_user.user_id }, exp)
        refresh_token = JwtHandler.encode_jwt_token({ user_id: matched_user.user_id }, ref_exp)
        render json: { issuccess: true, message: "Login success", token: generated_token, refresh_token: refresh_token, exp: exp.to_i, ref_exp: ref_exp.to_i }, status: :ok

      else
        render json: { issuccess: false, message: "Invalid password" }, status: :ok
      end
    end
  end
  def signup
    user = User.new(auth_params)
    puts user
    if user.save
      render json: { issuccess: true, message: "Account created successfully" }, status: :ok
    else
      render json: { issuccess: false, message: user.errors.full_messages.to_sentence }, status: :ok
    end
  end

  def me
    render json: { isuccess: true, user: current_user }
  end

  def delete_user
    if current_user.destroy
      render json: { issuccess: true, message: "Account deleted successfully" }, status: :ok
    else
      render json: { issuccess: false, message: "Unable to delete the account" }, status: :ok
    end
  end


 def refresh_access_token
   refresh_token_from_body = refresh_params[:refresh_token]
   if refresh_token_from_body.nil?
     render json: { issuccess: false, message: "Invalid refresh token" }, status: :ok
     return
   end
   begin
     decoded_refresh_token = JwtHandler.decode_jwt_token(refresh_token_from_body)
     matching_user = User.find(decoded_refresh_token[:user_id])
     new_access_token = JwtHandler.encode_jwt_token({ user_id: matching_user.user_id }) # default uses 24 hours

     render json: { issucess: true, access_token: new_access_token }


   rescue ActiveRecord::RecordNotFound
     render json: { issuccess: false, message: "Invalid access token" }, status: :ok
   rescue JWT::DecodeError
     render json: { issucess: false, message: "Unable to decode token" }, status: :ok
   rescue JWT::ExpiredSignature
     render json: { issucess: false, message: "Token expired" }, status: :ok # then logout user in front end
   rescue => e
     render json: { issucess: false, message: e.message }, status: :ok
   end
 end






  private
  def auth_params
    params.permit(:email, :password, :user_name)
  end

  def refresh_params
    params.permit(:refresh_token)
  end
end
