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
        send_create_shop_prompt(chat_id: chat_id_for(message), user: user)
      elsif language_selection?(message)
        update_language(user:, callback_query: message)
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
      ensure_devise_mapping!
      telegram_id = telegram_user_id_for(message)
      User.find_or_create_by!(telegram_id: telegram_id) do |user|
        user.email = "telegram-#{telegram_id}@example.invalid"
        user.uid = user.email
        user.provider = "email"
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

    def update_language(user:, callback_query:)
      language = callback_query["data"].split("_").last
      language = "en" unless %w[en am].include?(language)

      user.update!(language: language)
      message_sender.call(
        chat_id: callback_query.dig("message", "chat", "id"),
        text: I18n.t("telegram.language_updated", locale: language),
        reply_markup: Telegram::KeyboardBuilder.main_menu(language:)
      )
    end

    def handle_callback(user:, callback_query:)
      data = callback_query["data"].to_s

      case data
      when /\Aset_lang_/
        update_language(user:, callback_query:)
      when "cmd_createshop"
        send_create_shop_prompt(chat_id: chat_id_for(callback_query), user: user)
      when /\Arestock_(\d+)\z/
        restock_product(chat_id: chat_id_for(callback_query), user: user, product_id: Regexp.last_match(1))
      else
        send_unknown_message(chat_id: chat_id_for(callback_query), language: user.language)
      end
    end

    def handle_conversation(user:, message:)
      case user.bot_state
      when STATES[:AWAITING_SHOP_NAME], STATES[:AWAITING_SHOP_USERNAME]
        user.update!(bot_state: STATES[:NONE])
        send_create_shop_prompt(chat_id: chat_id_for(message), user: user)
      else
        user.update!(bot_state: STATES[:NONE])
        send_unknown_message(chat_id: chat_id_for(message), language: user.language)
      end
    end

    def send_create_shop_prompt(chat_id:, user:)
      app_url = "#{app_url_base}/setup-shop?user_id=#{user.id}"

      message_sender.call(
        chat_id: chat_id,
        text: I18n.t("telegram.createshop.start", locale: user.language),
        reply_markup: Telegram::KeyboardBuilder.create_shop_button(app_url:, language: user.language)
      )
    end

    def restock_product(chat_id:, user:, product_id:)
      product = Product.joins(shop: :user).find_by(id: product_id, shops: { user_id: user.id })

      unless product
        message_sender.call(
          chat_id: chat_id,
          text: I18n.t("errors.product_not_found", locale: user.language)
        )
        return
      end

      product.restock!
      message_sender.call(
        chat_id: chat_id,
        text: I18n.t("messages.restock_success", locale: user.language, total: product.stock_quantity)
      )
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

    def app_url_base
      ENV.fetch("APP_URL", "https://your-domain.com")
    end

    def ensure_devise_mapping!
      Rails.application.reload_routes! if defined?(Devise) && Devise.mappings.empty?
    end
  end
end
