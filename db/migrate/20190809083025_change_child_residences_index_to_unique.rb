class ChangeChildResidencesIndexToUnique < ActiveRecord::Migration[5.1]
  def change
    remove_index :child_residences, :child_id
    add_index    :child_residences, :child_id, unique: true
  end
end
