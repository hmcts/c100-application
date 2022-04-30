class AddChildrenPreviousProceedingsField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :children_previous_proceedings, :string
  end
end
