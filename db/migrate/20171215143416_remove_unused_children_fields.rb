class RemoveUnusedChildrenFields < ActiveRecord::Migration[5.0]
  def up
    remove_column :c100_applications, :children_same_parents
    remove_column :c100_applications, :children_same_parents_yes_details
    remove_column :c100_applications, :children_same_parents_no_details
    remove_column :c100_applications, :children_parental_responsibility_details
    remove_column :c100_applications, :children_residence
    remove_column :c100_applications, :children_residence_details
  end
end
