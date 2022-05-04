class RenameOtherChildrenField < ActiveRecord::Migration[5.0]
  def change
    rename_column :c100_applications, :other_children, :has_other_children
  end
end
