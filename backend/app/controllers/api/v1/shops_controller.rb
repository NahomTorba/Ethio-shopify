module Api
  module V1
    class ShopsController < BaseController
      before_action :set_shop, only: %i[show update]

      def index
        render json: { shops: current_shop_scope.order(created_at: :desc) }
      end

      def show
        render json: { shop: @shop, products: @shop.products.order(created_at: :desc) }
      end

      def update
        if @shop.update(shop_params)
          render json: { shop: @shop }
        else
          render json: { errors: @shop.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_shop
        @shop = current_shop_scope.find(params[:id])
      end

      def shop_params
        params.expect(shop: %i[name slug subdomain description currency active])
      end
    end
  end
end
