class AddDobEstimateToPeople < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :dob_estimate, :date
  end
end
