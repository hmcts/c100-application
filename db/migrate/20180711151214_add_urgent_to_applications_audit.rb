class AddUrgentToApplicationsAudit < ActiveRecord::Migration[5.1]
  def change
    add_column :completed_applications_audit, :urgent_hearing, :string
  end
end
