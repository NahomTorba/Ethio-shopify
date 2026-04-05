module Telegram
  class TelegramService
    def initialize
      @bot_token = ENV.fetch("TELEGRAM_BOT_TOKEN") { raise "TELEGRAM_BOT_TOKEN not set" }
    end

    def send_message(chat_id:, text:, reply_markup: nil)
      url = "https://api.telegram.org/bot#{@bot_token}/sendMessage"

      payload = {
        chat_id: chat_id,
        text: text
      }
      payload[:reply_markup] = reply_markup if reply_markup

      response = HTTParty.post(url, body: payload.to_json, headers: { "Content-Type" => "application/json" })

      if response.success?
        Rails.logger.info({ service: "telegram", action: "send_message_success", chat_id: chat_id }.to_json)
        true
      else
        Rails.logger.error({ service: "telegram", action: "send_message_failed", chat_id: chat_id, error: response.body }.to_json)
        false
      end
    end
  end
end
