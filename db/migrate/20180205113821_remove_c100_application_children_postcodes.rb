class RemoveC100ApplicationChildrenPostcodes < ActiveRecord::Migration[5.1]
  def change
    remove_column :c100_applications, :children_postcodes, :string
  end
end
