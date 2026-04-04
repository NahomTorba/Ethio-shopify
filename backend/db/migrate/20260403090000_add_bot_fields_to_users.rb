class AddBotFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :telegram_id, :string
    add_column :users, :language, :string, null: false, default: "en"

    add_index :users, :telegram_id, unique: true
  end
end
