class AddChildrenPostcodes < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :children_postcodes, :string
  end
end
