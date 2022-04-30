class AddEmailProvidedToSolicitors < ActiveRecord::Migration[5.2]
  def change
    add_column :solicitors, :email_provided, :string
  end
end
