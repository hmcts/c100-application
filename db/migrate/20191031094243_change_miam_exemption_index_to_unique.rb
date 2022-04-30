class ChangeMiamExemptionIndexToUnique < ActiveRecord::Migration[5.1]
  def change
    remove_index :miam_exemptions, :c100_application_id
    add_index    :miam_exemptions, :c100_application_id, unique: true
  end
end
