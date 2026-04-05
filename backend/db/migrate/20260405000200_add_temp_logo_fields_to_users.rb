class AddTempLogoFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :temp_logo_file_id, :string
  end
end
