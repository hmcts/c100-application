class RemovePassportPossessionFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :abduction_details, :passport_possession_mother, :boolean
    remove_column :abduction_details, :passport_possession_father, :boolean
    remove_column :abduction_details, :passport_possession_other,  :boolean
  end
end
