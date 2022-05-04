class AddDobToApplicants < ActiveRecord::Migration[5.0]
  def change
    add_column :applicants, :dob, :date
  end
end
