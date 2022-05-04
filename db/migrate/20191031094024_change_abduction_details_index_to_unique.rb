class ChangeAbductionDetailsIndexToUnique < ActiveRecord::Migration[5.1]
  def change
    remove_index :abduction_details, :c100_application_id
    add_index    :abduction_details, :c100_application_id, unique: true
  end
end
