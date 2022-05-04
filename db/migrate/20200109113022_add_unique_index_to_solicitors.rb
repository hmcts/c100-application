class AddUniqueIndexToSolicitors < ActiveRecord::Migration[5.2]
  def change
    remove_index :solicitors, :c100_application_id
    add_index    :solicitors, :c100_application_id, unique: true
  end
end
