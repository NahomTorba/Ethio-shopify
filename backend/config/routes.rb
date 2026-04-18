Rails.application.routes.draw do
  get "/up", to: proc { [ 200, { "Content-Type" => "application/json" }, [ '{"status":"ok"}' ] ] }

  mount_devise_token_auth_for "User",
                              at: "auth",
                              controllers: {
                                sessions: "auth/sessions",
                                registrations: "auth/registrations"
                              }

  # Serve frontend
  get "/setup-shop", to: "frontend#serve"
  get "/shop(*path)", to: "frontend#serve"
  get "(*path)", to: "frontend#serve"

  namespace :api do
    namespace :v1 do
      get "seller", to: "sellers#show"
      post "shops/setup", to: "public/shop_setups#create"

      resources :products, only: %i[index show create update destroy]
      resources :orders, only: %i[index show update]
      resources :shops, only: %i[index show update]

      namespace :public do
        resources :shop_setups, only: :create
        resources :shops, only: :show, param: :username
      end
    end
  end

  scope :webhooks do
    post "telegram", to: "webhooks/telegram#callback"
    post "shop_bot", to: "webhooks/shop_bot#callback"
    post "chapa", to: "webhooks/chapa#verify"
  end
end
