module Telegram
  class KeyboardBuilder
    def self.main_menu(language: "en")
      {
        inline_keyboard: [
          [
            { text: I18n.t("telegram.keyboard.english", locale: language), callback_data: "set_lang_en" },
            { text: I18n.t("telegram.keyboard.amharic", locale: language), callback_data: "set_lang_am" }
          ],
          [
            { text: I18n.t("telegram.keyboard.create_shop", locale: language), callback_data: "cmd_createshop" }
          ]
        ]
      }
    end

    def self.create_shop_button(app_url:, language: "en")
      {
        inline_keyboard: [
          [
            { text: I18n.t("telegram.keyboard.create_new_shop", locale: language), web_app: { url: app_url } }
          ]
        ]
      }
    end
  end
end
