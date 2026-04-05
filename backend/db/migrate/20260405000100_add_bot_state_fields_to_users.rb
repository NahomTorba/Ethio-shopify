class AddBotStateFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :bot_state, :string, default: "none"
    add_column :users, :temp_shop_name, :string
  end
end
