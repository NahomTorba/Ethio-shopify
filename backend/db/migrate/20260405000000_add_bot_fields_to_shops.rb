class AddBotFieldsToShops < ActiveRecord::Migration[8.1]
  def change
    add_column :shops, :telegram_bot_token, :string
    add_column :shops, :username, :string
    add_column :shops, :logo_url, :string
    add_column :shops, :user_id, :bigint

    add_index :shops, :username, unique: true
    add_index :shops, :user_id
  end
end
