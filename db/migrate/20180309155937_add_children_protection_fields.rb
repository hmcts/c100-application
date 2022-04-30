class AddChildrenProtectionFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :protection_orders, :string
    add_column :c100_applications, :protection_orders_details, :text
  end
end
