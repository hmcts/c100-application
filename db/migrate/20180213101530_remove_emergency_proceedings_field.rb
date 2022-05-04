class RemoveEmergencyProceedingsField < ActiveRecord::Migration[5.1]
  def change
    remove_column :c100_applications, :emergency_proceedings, :string
  end
end
