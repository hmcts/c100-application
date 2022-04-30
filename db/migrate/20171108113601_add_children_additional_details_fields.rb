class AddChildrenAdditionalDetailsFields < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :children_known_to_authorities, :string
    add_column :c100_applications, :children_known_to_authorities_details, :text

    add_column :c100_applications, :children_protection_plan, :string
    add_column :c100_applications, :children_protection_plan_details, :text

    add_column :c100_applications, :children_same_parents, :string
    add_column :c100_applications, :children_same_parents_yes_details, :text
    add_column :c100_applications, :children_same_parents_no_details, :text

    add_column :c100_applications, :children_parental_responsibility_details, :text

    add_column :c100_applications, :children_residence, :string
    add_column :c100_applications, :children_residence_details, :text
  end
end
