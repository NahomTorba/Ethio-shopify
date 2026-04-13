require 'httparty'

module Telegram
  class TelegramService
    def initialize(shop: nil)
      if shop&.telegram_bot_token
        @bot_token = shop.telegram_bot_token
      else
        @bot_token = ENV["TELEGRAM_BOT_TOKEN"]
      end
      if @bot_token.present?
        Rails.logger.info("TelegramService initialized with token: #{@bot_token[0..10]}...")
      else
        Rails.logger.warn("TelegramService initialized without a bot token; messages will be skipped")
      end
    end

    def send_message(chat_id:, text:, reply_markup: nil)
      return false if @bot_token.blank?

      url = "https://api.telegram.org/bot#{@bot_token}/sendMessage"
      Rails.logger.info("Sending message to chat_id: #{chat_id}, text: #{text[0..50]}...")

      payload = {
        chat_id: chat_id,
        text: text
      }
      payload[:reply_markup] = reply_markup if reply_markup

      begin
        response = HTTParty.post(url, body: payload.to_json, headers: { "Content-Type" => "application/json" })
        Rails.logger.info("Telegram response code: #{response.code}")
        Rails.logger.info("Telegram response body: #{response.body}")

        if response.success?
          Rails.logger.info({ service: "telegram", action: "send_message_success", chat_id: chat_id }.to_json)
          true
        else
          Rails.logger.error({ service: "telegram", action: "send_message_failed", chat_id: chat_id, error: response.body }.to_json)
          false
        end
      rescue => e
        Rails.logger.error("Error sending telegram message: #{e.message}")
        false
      end
    end
  end
end
