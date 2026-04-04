module Telegram
  class TelegramService
    def send_message(chat_id:, text:, reply_markup: nil)
      Rails.logger.info(
        {
          service: "telegram",
          action: "send_message",
          chat_id: chat_id,
          text: text,
          reply_markup: reply_markup
        }.to_json
      )

      true
    end
  end
end
