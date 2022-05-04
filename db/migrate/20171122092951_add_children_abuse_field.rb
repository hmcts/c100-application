class AddChildrenAbuseField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :children_abuse, :string
  end
end
