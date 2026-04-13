module Telegram
  class ShopBotHandler
    def initialize(shop:)
      @shop = shop
      @message_sender = MessageSender.new(shop: shop)
    end

    def process(payload:)
      message = extract_message(payload)
      return if message.blank?

      telegram_id = message.dig("from", "id").to_s

      if payload["callback_query"]
        handle_callback(callback_query: payload["callback_query"])
        return
      end

      if start_command?(message)
        if owner?(telegram_id)
          send_owner_welcome(chat_id: chat_id_for(message))
        else
          send_customer_welcome(chat_id: chat_id_for(message))
        end
      else
        send_menu(chat_id: chat_id_for(message))
      end
    end

    private

    attr_reader :shop, :message_sender

    def extract_message(payload)
      payload["callback_query"] || payload["message"]
    end

    def start_command?(message)
      message["text"] == "/start"
    end

    def owner?(telegram_id)
      shop.user&.telegram_id == telegram_id
    end

    def handle_callback(callback_query)
      data = callback_query["data"]
      # Handle other callbacks
    end

    def send_owner_welcome(chat_id:)
      web_app_url = FrontendUrlBuilder.shop(username: shop.username, mode: "owner")

      message_sender.call(
        chat_id: chat_id,
        text: "Manage your store",
        reply_markup: owner_keyboard(web_app_url: web_app_url)
      )
    end

    def send_customer_welcome(chat_id:)
      web_app_url = FrontendUrlBuilder.shop(username: shop.username, mode: "customer")

      message_sender.call(
        chat_id: chat_id,
        text: "Browse products",
        reply_markup: customer_keyboard(web_app_url: web_app_url)
      )
    end

    def owner_keyboard(web_app_url:)
      {
        inline_keyboard: [
          [
            { text: "Manage Store", web_app: { url: web_app_url } }
          ]
        ]
      }
    end

    def customer_keyboard(web_app_url:)
      {
        inline_keyboard: [
          [
            { text: "Browse Products", web_app: { url: web_app_url } }
          ]
        ]
      }
    end

    def send_menu(chat_id:)
      telegram_id = message_dig(message, "from", "id")&.to_s
      
      if owner?(telegram_id)
        web_app_url = FrontendUrlBuilder.shop(username: shop.username, mode: "owner")
        message_sender.call(
          chat_id: chat_id,
          text: "Manage your store",
          reply_markup: owner_keyboard(web_app_url: web_app_url)
        )
      else
        web_app_url = FrontendUrlBuilder.shop(username: shop.username, mode: "customer")
        message_sender.call(
          chat_id: chat_id,
          text: "Browse products",
          reply_markup: customer_keyboard(web_app_url: web_app_url)
        )
      end
    end

    def message_dig(hash, *keys)
      keys.reduce(hash) { |h, k| h&.dig(k) }
    end

    def chat_id_for(message)
      message.dig("chat", "id") || message.dig("message", "chat", "id")
    end
  end
end
