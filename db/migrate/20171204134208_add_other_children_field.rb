class AddOtherChildrenField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :other_children, :string
  end
end
