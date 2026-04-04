class Product < ApplicationRecord
  belongs_to :shop
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :sku, uniqueness: true, allow_blank: true
end
