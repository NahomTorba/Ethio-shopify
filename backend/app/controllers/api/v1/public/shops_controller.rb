module Api
  module V1
    module Public
      class ShopsController < BaseController
        before_action :set_shop

        def show
          render json: {
            shop: @shop.as_json(only: %i[id name username description logo_url welcome_message web_app_button_url]),
            products: @shop.products.order(created_at: :desc).as_json(
              only: %i[id name description price stock_quantity active]
            )
          }
        end

        private

        def set_shop
          @shop = Shop.includes(:products).find_by!(username: params[:username])
        end
      end
    end
  end
end
