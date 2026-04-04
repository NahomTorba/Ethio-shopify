class Shop < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :products, dependent: :destroy
end
