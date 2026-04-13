require "net/http"

module Telegram
  class WebhookRegistrar
    def self.call(bot_token:)
      new(bot_token: bot_token).call
    end

    def initialize(bot_token:)
      @bot_token = bot_token
    end

    def call
      return if bot_token.blank?

      Net::HTTP.get(uri)
      Rails.logger.info("Webhook set to: #{webhook_url}")
    rescue StandardError => e
      Rails.logger.error("Failed to set webhook: #{e.message}")
    end

    private

    attr_reader :bot_token

    def uri
      URI("https://api.telegram.org/bot#{bot_token}/setWebhook?url=#{webhook_url}")
    end

    def webhook_url
      "#{ENV.fetch('APP_URL', 'https://your-domain.com')}/webhooks/shop_bot?token=#{bot_token}"
    end
  end
end
