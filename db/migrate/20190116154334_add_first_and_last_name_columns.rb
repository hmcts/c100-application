class AddFirstAndLastNameColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :people, :name, :first_name
    rename_column :people, :full_name, :last_name
  end
end
