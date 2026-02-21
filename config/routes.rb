Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      post "/login", to: "auth#login"
      post "/signup", to: "auth#signup"
      get "/me", to: "auth#me"
      delete "/deleteuser", to:"auth#delete_user"
    end
  end
end
