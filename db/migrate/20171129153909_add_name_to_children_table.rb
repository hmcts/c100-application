class AddNameToChildrenTable < ActiveRecord::Migration[5.0]
  def change
    add_column :children, :name, :string
  end
end
