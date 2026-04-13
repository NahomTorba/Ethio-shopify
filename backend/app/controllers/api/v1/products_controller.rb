module Api
  module V1
    class ProductsController < BaseController
      before_action :set_product, only: %i[show update destroy]
      skip_before_action :authenticate_seller!, only: :create

      def create
        shop = Shop.find_by(id: params[:product][:shop_id])
        return render json: { error: "Shop not found" }, status: :not_found if shop.nil?

        product = Product.new(product_params)

        if product.save
          render json: { product: product }, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        render json: { product: @product }
      end

      def update
        if @product.update(product_params)
          render json: { product: @product }
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.expect(product: %i[name description price stock_quantity sku active shop_id category_id])
      end
    end
  end
end
