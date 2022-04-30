class ChangeAuditColumnsToNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :completed_applications_audit, :reference_code, false
    change_column_null :completed_applications_audit, :court, false
  end
end
