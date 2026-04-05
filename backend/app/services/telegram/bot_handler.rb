module Telegram
  class BotHandler
    STATES = {
      NONE: "none",
      AWAITING_SHOP_NAME: "awaiting_shop_name",
      AWAITING_SHOP_USERNAME: "awaiting_shop_username"
    }.freeze

    def initialize(message_sender: MessageSender.new)
      @message_sender = message_sender
    end

    def process(payload:)
      message = extract_message(payload)
      return if message.blank?

      user = find_or_initialize_user(message)
      state = user.bot_state

      if payload["callback_query"]
        handle_callback(user: user, callback_query: payload["callback_query"])
        return
      end

      if state != STATES[:NONE]
        handle_conversation(user: user, message: message)
        return
      end

      if start_command?(message)
        send_welcome(chat_id: chat_id_for(message), language: user.language)
      elsif createshop_command?(message)
        start_createshop_flow(user: user, chat_id: chat_id_for(message))
      else
        send_unknown_message(chat_id: chat_id_for(message), language: user.language)
      end
    end

    private

    attr_reader :message_sender

    def extract_message(payload)
      payload["callback_query"] || payload["message"]
    end

    def find_or_initialize_user(message)
      telegram_id = telegram_user_id_for(message)
      User.find_or_create_by!(telegram_id: telegram_id) do |user|
        user.email = "telegram-#{telegram_id}@example.invalid"
        user.password = SecureRandom.hex(16)
        user.password_confirmation = user.password
        user.name = message.dig("from", "first_name").presence || "Telegram Seller"
      end
    end

    def start_command?(message)
      message["text"] == "/start"
    end

    def createshop_command?(message)
      message["text"] == "/createshop"
    end

    def language_selection?(message)
      message["data"].to_s.start_with?("set_lang_")
    end

    def handle_callback(user:, callback_query:)
      data = callback_query["data"]

      if data&.start_with?("set_lang_")
        update_language(user: user, callback_query: callback_query)
      elsif data == "cmd_createshop"
        start_createshop_flow(user: user, chat_id: callback_query.dig("message", "chat", "id"))
      end
    end

    def update_language(user:, callback_query:)
      language = callback_query["data"].split("_").last
      language = "en" unless %w[en am].include?(language)

      user.update!(language: language)
      message_sender.call(
        chat_id: callback_query.dig("message", "chat", "id"),
        text: I18n.t("telegram.language_updated", locale: language)
      )
    end

    def start_createshop_flow(user:, chat_id:)
      user.update!(bot_state: STATES[:AWAITING_SHOP_NAME])

      setup_url = "#{ENV.fetch('APP_URL', 'https://your-domain.com')}/setup-shop?user_id=#{user.id}"

      message_sender.call(
        chat_id: chat_id,
        text: I18n.t("telegram.createshop.start", locale: user.language),
        reply_markup: Telegram::KeyboardBuilder.create_shop_button(
          app_url: setup_url,
          language: user.language
        )
      )
    end

    def handle_conversation(user:, message:)
      chat_id = chat_id_for(message)
      state = user.bot_state

      case state
      when STATES[:AWAITING_SHOP_NAME]
        user.update!(temp_shop_name: message["text"], bot_state: STATES[:AWAITING_SHOP_USERNAME])
        message_sender.call(
          chat_id: chat_id,
          text: I18n.t("telegram.createshop.ask_username", locale: user.language)
        )

      when STATES[:AWAITING_SHOP_USERNAME]
        username = message["text"]&.gsub("@", "")&.gsub("_bot", "")&.strip
        username = "#{username}_bot" unless username&.end_with?("_bot")

        if Shop.find_by(username: username)
          message_sender.call(
            chat_id: chat_id,
            text: I18n.t("telegram.createshop.username_taken", locale: user.language)
          )
        else
          create_shop(user: user, username: username, chat_id: chat_id)
        end
      end
    end

    def create_shop(user:, username:, chat_id:)
      shop_name = user.temp_shop_name

      shop = Shop.create!(
        name: shop_name,
        username: username,
        user: user,
        active: true,
        welcome_message: "Hello! Welcome to #{shop_name}! Browse our products and place orders easily.",
        web_app_button_url: "#{ENV.fetch('APP_URL', 'https://your-domain.com')}/api/v1/shop/#{username}"
      )

      message_sender.call(
        chat_id: chat_id,
        text: I18n.t("telegram.createshop.success", locale: user.language) + "\n\n" +
          "Your shop link: t.me/#{username}?start=welcome\n\n" +
          "Note: Create a bot at @BotFather with username '#{username}' and set webhook to your server to activate the shop."
      )

      user.update!(bot_state: STATES[:NONE], temp_shop_name: nil)
    end

    def send_welcome(chat_id:, language:)
      message_sender.call(
        chat_id: chat_id,
        text: I18n.t("telegram.welcome", locale: language),
        reply_markup: Telegram::KeyboardBuilder.main_menu(language: language)
      )
    end

    def send_unknown_message(chat_id:, language:)
      message_sender.call(
        chat_id: chat_id,
        text: I18n.t("telegram.unknown_command", locale: language),
        reply_markup: Telegram::KeyboardBuilder.main_menu(language: language)
      )
    end

    def telegram_user_id_for(message)
      message.dig("from", "id").to_s
    end

    def chat_id_for(message)
      message.dig("chat", "id") || message.dig("message", "chat", "id")
    end
  end
end
