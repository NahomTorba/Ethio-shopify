module Api
  module V1
    class ShopController < ActionController::API
      def show
        @shop = Shop.find_by!(username: params[:username])
        render "shop/show"
      end
    end
  end
end