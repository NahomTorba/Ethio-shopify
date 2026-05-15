class ShopsController < ApplicationController
  def create
    shop = Shops::CreateService.call(shop_params)
    render json: shop, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  private
  def shop_params
    params.require(:shop).permit(:name, :telegram_bot_token)
  end
end