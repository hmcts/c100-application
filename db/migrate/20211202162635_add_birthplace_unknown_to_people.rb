class AddBirthplaceUnknownToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :birthplace_unknown, :boolean, default: false
  end
end
