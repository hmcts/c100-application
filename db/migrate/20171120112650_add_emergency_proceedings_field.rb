class AddEmergencyProceedingsField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :emergency_proceedings, :string
  end
end
