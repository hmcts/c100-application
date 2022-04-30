class AddNumberOfChildren < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :number_of_children, :integer
  end
end
