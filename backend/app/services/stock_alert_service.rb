class StockAlertService
  RESTOCK_AMOUNT = 10

  def initialize(product)
    @product = product
    @seller = product.shop.user
  end

  def call
    return unless eligible_for_alert?

    send_low_stock_alert
  end

  private

  attr_reader :product, :seller

  def eligible_for_alert?
    seller.telegram_id.present? && !recent_alert_sent?
  end

  def recent_alert_sent?
    # In production, check for recent alerts to avoid spam
    false
  end

  def send_low_stock_alert
    message_sender.call(
      chat_id: seller.telegram_id,
      text: alert_message,
      reply_markup: Telegram::KeyboardBuilder.low_stock_alert(product_id: product.id)
    )
  end

  def alert_message
    I18n.t("notifications.low_stock_alert", {
      product_name: product.name,
      count: product.stock_quantity,
      locale: seller.language || :en
    })
  end

  def message_sender
    @message_sender ||= Telegram::MessageSender.new
  end
end
