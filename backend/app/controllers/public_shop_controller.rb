class PublicShopController < ActionController::API
  def show
    @shop = Shop.find_by!(username: params[:username])
    render "public_shop/show"
  end
end