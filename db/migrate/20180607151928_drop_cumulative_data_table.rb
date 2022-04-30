class DropCumulativeDataTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :cumulative_data
  end
end
