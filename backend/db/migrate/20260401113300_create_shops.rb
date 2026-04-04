class CreateShops < ActiveRecord::Migration[8.1]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :slug
      t.string :subdomain
      t.text :description
      t.string :currency, null: false, default: "ETB"
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :shops, :slug, unique: true
    add_index :shops, :subdomain, unique: true
  end
end
