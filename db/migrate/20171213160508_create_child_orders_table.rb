class CreateChildOrdersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :child_orders, id: :uuid do |t|
      t.uuid :child_id, index: true
      t.string :orders, array: true, default: []
    end

    add_foreign_key :child_orders, :people, column: :child_id
  end
end
