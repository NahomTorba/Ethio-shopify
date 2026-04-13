Rails.application.routes.draw do
  get "/up", to: proc { [200, { "Content-Type" => "application/json" }, ['{"status":"ok"}']] }

  mount_devise_token_auth_for "User",
                              at: "auth",
                              controllers: {
                                sessions: "auth/sessions",
                                registrations: "auth/registrations"
                              }

  scope module: :web do
    get "/shop/:username", to: "app_links#shop"
    get "/setup-shop", to: "app_links#setup_shop"
  end

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
