Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      post "/login", to: "auth#login"
      post "/signup", to: "auth#signup"
    end
  end
end
