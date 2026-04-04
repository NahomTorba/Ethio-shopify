class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 12, scale: 2, null: false, default: 0
      t.integer :stock_quantity, null: false, default: 0
      t.string :sku
      t.boolean :active, null: false, default: true
      t.references :shop, null: false, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end

    add_index :products, :sku, unique: true
  end
end
