class AddOrdersFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :orders, :string, array: true, default: []
    add_column :c100_applications, :orders_additional_details, :text
  end
end
