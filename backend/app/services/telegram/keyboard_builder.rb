module Telegram
  class KeyboardBuilder
    def self.main_menu(language: "en")
      {
        inline_keyboard: [
          [
            { text: language_button_label("en"), callback_data: "set_lang_en" },
            { text: language_button_label("am"), callback_data: "set_lang_am" }
          ]
        ]
      }
    end

    def self.language_button_label(language)
      case language
      when "am"
        "አማርኛ"
      else
        "English"
      end
    end
  end
end
