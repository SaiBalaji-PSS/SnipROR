Rails.application.routes.draw do
  namespace :api do
    namespace :auth do
      post "/login", to: "auth#login"
      post "/signup", to: "auth#signup"
      get "/me", to: "auth#me"
      delete "/deleteuser", to: "auth#delete_user"
    end
  end
  namespace :api do
    namespace :snip do
      post "/shortenurl", to: "url#shorten_url"
      get "/allurls", to: "url#get_all_urls" # order matters here
      get "/:code", to: "url#redirect_to_full_url"

      delete "/deleteurl/:id", to: "url#delete_url_with_id"
    end
  end
end
