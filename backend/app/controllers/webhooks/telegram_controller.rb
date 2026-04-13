module Webhooks
  class TelegramController < ActionController::API
    def callback
      Telegram::BotHandler.new.process(payload: params.to_unsafe_h)
      head :ok
    end
  end
end
