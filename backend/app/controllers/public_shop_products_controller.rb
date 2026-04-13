class PublicShopProductsController < ActionController::API
  before_action :set_shop
  before_action :set_product, only: :update

  def index
    render json: { products: serialized_products(@shop.products.for_seller_inventory) }
  end

  def update
    if @product.update(product_params)
      render json: { product: serialize_product(@product) }
    else
      render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_shop
    @shop = Shop.find_by!(username: params[:username])
  end

  def set_product
    @product = @shop.products.find(params[:id])
  end

  def product_params
    params.expect(product: %i[active stock_quantity])
  end

  def serialized_products(products)
    products.map { |product| serialize_product(product) }
  end

  def serialize_product(product)
    {
      id: product.id,
      name: product.name.to_s,
      description: product.description.to_s,
      price: product.price.to_f,
      stock_quantity: product.stock_quantity.to_i,
      active: product.active?,
      hidden: product.hidden?,
      out_of_stock: product.out_of_stock?
    }
  end
end
