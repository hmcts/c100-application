class AddEmailProvidedToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :email_provided, :string
  end
end
