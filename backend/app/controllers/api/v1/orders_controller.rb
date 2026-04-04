module Api
  module V1
    class OrdersController < BaseController
      before_action :set_order, only: %i[show update]

      def index
        render json: { orders: Order.includes(:shop).order(created_at: :desc) }
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
        @order = Order.find(params[:id])
      end

      def order_params
        params.expect(order: %i[status total_price telegram_user_id payment_reference shop_id])
      end
    end
  end
end
