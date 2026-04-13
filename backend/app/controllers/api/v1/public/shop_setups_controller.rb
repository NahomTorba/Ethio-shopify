module Api
  module V1
    module Public
      class ShopSetupsController < BaseController
        def create
          user = User.find_by(id: shop_setup_params[:user_id])
          return render json: { error: "User not found" }, status: :not_found if user.nil?

          shop = user.shops.create!(
            name: shop_setup_params[:shop_name],
            username: shop_setup_params[:shop_username],
            active: true,
            welcome_message: shop_setup_params[:description].presence || "Welcome to #{shop_setup_params[:shop_name]}!",
            telegram_bot_token: shop_setup_params[:bot_token],
            web_app_button_url: FrontendUrlBuilder.shop(username: shop_setup_params[:shop_username])
          )

          Telegram::WebhookRegistrar.call(bot_token: shop_setup_params[:bot_token])

          render json: {
            shop: shop.slice(:id, :name, :username, :welcome_message, :web_app_button_url),
            message: "Shop created successfully!"
          }, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
        end

        private

        def shop_setup_params
          params.permit(:user_id, :shop_name, :shop_username, :description, :bot_token)
        end
      end
    end
  end
end
