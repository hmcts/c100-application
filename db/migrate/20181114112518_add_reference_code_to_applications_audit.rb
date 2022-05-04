class AddReferenceCodeToApplicationsAudit < ActiveRecord::Migration[5.1]
  def change
    add_column :completed_applications_audit, :reference_code, :string
    add_index  :completed_applications_audit, :reference_code, unique: true
  end
end
