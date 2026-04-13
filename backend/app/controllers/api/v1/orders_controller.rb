module Api
  module V1
    class OrdersController < BaseController
      before_action :set_order, only: %i[show update]

      def index
        orders = Order.includes(:shop)
                      .where(shop: current_shop_scope)
                      .order(created_at: :desc)

        render json: { orders: orders }
      end

      def show
        render json: { order: @order }
      end

      def update
        if @order.update(order_params)
          render json: { order: @order }
        else
          render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_order
        @order = Order.where(shop: current_shop_scope).find(params[:id])
      end

      def order_params
        params.expect(order: %i[status total_price telegram_user_id payment_reference shop_id])
      end
    end
  end
end
