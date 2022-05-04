class AddSgOrderToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :special_guardianship_order, :string
  end
end
