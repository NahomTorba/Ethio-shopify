module Telegram
  class MessageSender
    def initialize(shop: nil, telegram_service: nil)
      @shop = shop
      @telegram_service = telegram_service || TelegramService.new(shop: shop)
    end

    def call(chat_id:, text:, reply_markup: nil)
      @telegram_service.send_message(chat_id:, text:, reply_markup:)
    end
  end
end
