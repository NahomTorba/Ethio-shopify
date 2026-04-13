module Api
  module V1
    class ShopsController < ActionController::API
      before_action :set_shop, only: %i[show update]

      def show
        render json: { shop: @shop, products: @shop.products.visible_to_buyers.for_seller_inventory }
      end

      def update
        if @shop.update(shop_params)
          render json: { shop: @shop }
        else
          render json: { errors: @shop.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def setup
        user = User.find_by(id: params[:user_id])
        return render json: { error: "User not found" }, status: :not_found if user.nil?

        shop = Shop.create!(
          name: params[:shop_name],
          username: params[:shop_username],
          user: user,
          active: true,
          welcome_message: params[:description] || "Welcome to #{params[:shop_name]}!",
          telegram_bot_token: params[:bot_token],
          web_app_button_url: "#{ENV.fetch('APP_URL', 'https://your-domain.com')}/shop/#{params[:shop_username]}"
        )

        set_shop_webhook(params[:bot_token])

        render json: { shop: shop, message: "Shop created successfully!" }
      end

      private

      def set_shop
        @shop = Shop.find(params[:id])
      end

      def shop_params
        params.expect(shop: %i[name slug subdomain description currency active])
      end

      def set_shop_webhook(bot_token)
        domain = ENV.fetch('APP_URL', 'https://your-domain.com')
        webhook_url = "#{domain}/webhooks/shop_bot"
        url = "https://api.telegram.org/bot#{bot_token}/setWebhook?url=#{webhook_url}"
        HTTParty.get(url)
      rescue => e
        Rails.logger.error("Failed to set webhook: #{e.message}")
      end
    end
  end
end
