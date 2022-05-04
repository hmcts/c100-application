class AddCurrentLocationField < ActiveRecord::Migration[5.1]
  def change
    add_column :abduction_details, :current_location, :text
  end
end
