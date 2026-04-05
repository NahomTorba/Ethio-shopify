class AddWelcomeMessageToShops < ActiveRecord::Migration[8.1]
  def change
    add_column :shops, :welcome_message, :text
    add_column :shops, :web_app_button_url, :string
  end
end