class Product < ApplicationRecord
  belongs_to :shop
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :sku, uniqueness: true, allow_blank: true

  after_save :check_low_stock, if: :saved_change_to_stock_quantity?

  def low_stock?
    stock_quantity <= low_stock_threshold
  end

  def restock!(amount = 10)
    increment!(:stock_quantity, amount)
  end

  private

  def check_low_stock
    StockAlertService.new(self).call if low_stock?
  end
end
