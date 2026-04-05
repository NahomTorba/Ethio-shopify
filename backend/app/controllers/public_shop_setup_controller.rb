class PublicShopSetupController < ActionController::API
  def create
    Rails.logger.info "=== PUBLIC SHOP SETUP CREATE CALLED ==="
    Rails.logger.info "params: #{params.inspect}"

    user = User.find_by(id: params[:user_id])
    return render json: { error: "User not found" }, status: :not_found if user.nil?
    
    return render json: { error: "Missing required fields" }, status: :bad_request if params[:shop_name].blank? || params[:shop_username].blank? || params[:bot_token].blank?

    shop = Shop.create!(
      name: params[:shop_name],
      username: params[:shop_username],
      user: user,
      active: true,
      welcome_message: params[:description] || "Welcome to #{params[:shop_name]}!",
      telegram_bot_token: params[:bot_token],
      web_app_button_url: "#{ENV.fetch('APP_URL', 'https://your-domain.com')}/shop/#{params[:shop_username]}"
    )

    set_shop_webhook(params[:bot_token])

    render json: { shop: { id: shop.id, name: shop.name, username: shop.username }, message: "Shop created successfully!" }
  rescue => e
    Rails.logger.error "Error creating shop: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_shop_webhook(bot_token)
    require 'net/http'
    domain = ENV.fetch('APP_URL', 'https://your-domain.com')
    webhook_url = "#{domain}/webhooks/shop_bot?token=#{bot_token}"
    uri = URI("https://api.telegram.org/bot#{bot_token}/setWebhook?url=#{webhook_url}")
    Net::HTTP.get(uri)
    Rails.logger.info "Webhook set to: #{webhook_url}"
  rescue => e
    Rails.logger.error("Failed to set webhook: #{e.message}")
  end
end