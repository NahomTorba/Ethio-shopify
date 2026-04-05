module Webhooks
  class ShopBotController < ActionController::API
    before_action :verify_shop_bot

    def callback
      Telegram::ShopBotHandler.new(shop: @shop).process(payload: params.to_unsafe_h)
      head :ok
    end

    private

    def verify_shop_bot
      bot_token = params[:token] || request.headers['X-Telegram-Bot-Token']
      @shop = Shop.find_by(telegram_bot_token: bot_token)

      head :unauthorized if @shop.nil?
    end

    def payload
      params.to_unsafe_h
    end
  end
end