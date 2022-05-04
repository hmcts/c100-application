class ChangeChildOrdersIndexToUnique < ActiveRecord::Migration[5.1]
  def change
    remove_index :child_orders, :child_id
    add_index    :child_orders, :child_id, unique: true
  end
end
