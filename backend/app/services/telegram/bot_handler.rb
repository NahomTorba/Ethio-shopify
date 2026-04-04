module Telegram
  class BotHandler
    def initialize(message_sender: MessageSender.new)
      @message_sender = message_sender
    end

    def process(payload:)
      message = extract_message(payload)
      return if message.blank?

      user = find_or_initialize_user(message)

      if start_command?(message)
        send_welcome(chat_id: chat_id_for(message), language: user.language)
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

    def send_welcome(chat_id:, language:)
      message_sender.call(
        chat_id: chat_id,
        text: I18n.t("telegram.welcome", locale: language),
        reply_markup: Telegram::KeyboardBuilder.main_menu(language:)
      )
    end

    def send_unknown_message(chat_id:, language:)
      message_sender.call(
        chat_id: chat_id,
        text: I18n.t("telegram.unknown_command", locale: language),
        reply_markup: Telegram::KeyboardBuilder.main_menu(language:)
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
