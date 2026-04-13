class AddLowStockThresholdToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :low_stock_threshold, :integer, default: 5
  end
end
