require "test_helper"

class ProductVisibilityTest < ActionDispatch::IntegrationTest
  test "buyer product list hides unpublished products" do
    shop = Shop.create!(name: "Roast House", slug: "roast-house", subdomain: "roast-house")
    visible_product = Product.create!(name: "Coffee Beans", price: 12, stock_quantity: 8, shop: shop, active: true)
    Product.create!(name: "Hidden Beans", price: 10, stock_quantity: 5, shop: shop, active: false)

    get "/list-products/#{shop.id}", as: :json

    assert_response :success
    products = response.parsed_body["products"]
    assert_equal [visible_product.id], products.map { |product| product["id"] }
  end

  test "seller owner products list keeps hidden products with hidden badge data" do
    shop = Shop.create!(name: "Roast House", slug: "roast-house-owner", subdomain: "roast-house-owner", username: "roast-house-owner")
    hidden_product = Product.create!(name: "Hidden Beans", price: 10, stock_quantity: 5, shop: shop, active: false)

    get "/shop/#{shop.username}/owner-products", as: :json

    assert_response :success
    product = response.parsed_body["products"].find { |entry| entry["id"] == hidden_product.id }
    assert_equal false, product["active"]
    assert_equal true, product["hidden"]
  end

  test "seller can hide a product without deleting it" do
    shop = Shop.create!(name: "Roast House", slug: "roast-house-toggle", subdomain: "roast-house-toggle", username: "roast-house-toggle")
    product = Product.create!(name: "Coffee Beans", price: 12, stock_quantity: 8, shop: shop, active: true)

    patch "/shop/#{shop.username}/products/#{product.id}/visibility",
          params: { product: { active: false } },
          as: :json

    assert_response :success
    assert_equal false, product.reload.active
  end
end
