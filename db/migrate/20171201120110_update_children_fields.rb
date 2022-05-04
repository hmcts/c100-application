class UpdateChildrenFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :children, :orders_applied_for, :text
    remove_column :children, :applicants_relationship, :text
    remove_column :children, :respondents_relationship, :text

    add_column :children, :age_estimate, :string
    add_column :children, :kind, :string
  end
end
