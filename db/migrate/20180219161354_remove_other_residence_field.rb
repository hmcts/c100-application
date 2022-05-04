class RemoveOtherResidenceField < ActiveRecord::Migration[5.1]
  def change
    remove_column :child_residences, :other, :boolean
    remove_column :child_residences, :other_full_name, :string
  end
end
