class DropChildrenTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :children
  end
end
