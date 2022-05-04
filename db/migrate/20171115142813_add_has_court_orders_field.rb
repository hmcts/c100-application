class AddHasCourtOrdersField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :has_court_orders, :string
  end
end
