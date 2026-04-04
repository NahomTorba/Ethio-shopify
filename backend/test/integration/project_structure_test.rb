require "test_helper"

class ProjectStructureTest < ActionDispatch::IntegrationTest
  test "telegram webhook route is wired to a controller" do
    post "/webhooks/telegram",
         params: { message: { from: { id: "123", first_name: "Demo" }, chat: { id: "321" }, text: "/start" } },
         as: :json

    assert_response :success
    assert_equal "123", User.order(:created_at).last.telegram_id
  end

  test "product model associations are available" do
    shop = Shop.create!(name: "Test Shop", slug: "test-shop", subdomain: "test-shop")
    product = Product.create!(name: "Coffee", price: 10, stock_quantity: 5, shop: shop)

    assert_equal shop.id, product.shop_id
    assert_includes shop.products, product
  end

  test "bot messages switch between english and amharic from start to follow up" do
    sender = FakeMessageSender.new
    handler = Telegram::BotHandler.new(message_sender: sender)

    handler.process(
      payload: {
        "message" => {
          "from" => { "id" => "500", "first_name" => "Abel" },
          "chat" => { "id" => "900" },
          "text" => "/start"
        }
      }
    )

    assert_equal "Welcome to Sellz Telegram Bot. Choose your language and start managing your shop.", sender.messages.last[:text]
    assert_equal "English", sender.messages.last.dig(:reply_markup, :inline_keyboard, 0, 0, :text)
    assert_equal "አማርኛ", sender.messages.last.dig(:reply_markup, :inline_keyboard, 0, 1, :text)

    handler.process(
      payload: {
        "callback_query" => {
          "from" => { "id" => "500" },
          "data" => "set_lang_am",
          "message" => { "chat" => { "id" => "900" } }
        }
      }
    )

    assert_equal "ቋንቋው ወደ አማርኛ ተቀይሯል።", sender.messages.last[:text]
    assert_equal "am", User.find_by(telegram_id: "500").language

    handler.process(
      payload: {
        "message" => {
          "from" => { "id" => "500", "first_name" => "Abel" },
          "chat" => { "id" => "900" },
          "text" => "inventory"
        }
      }
    )

    assert_equal "ይህን መልእክት አልገባኝም። ከታች ያሉትን የቋንቋ አዝራሮች ይጠቀሙ ወይም /start ይላኩ።", sender.messages.last[:text]
  end

  class FakeMessageSender
    attr_reader :messages

    def initialize
      @messages = []
    end

    def call(chat_id:, text:, reply_markup: nil)
      @messages << {
        chat_id: chat_id,
        text: text,
        reply_markup: reply_markup
      }
    end
  end
end
