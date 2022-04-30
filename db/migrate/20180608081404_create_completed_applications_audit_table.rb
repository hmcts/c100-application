class CreateCompletedApplicationsAuditTable < ActiveRecord::Migration[5.1]
  def change
    create_table :completed_applications_audit, id: false do |t|
      t.datetime :started_at, null: false
      t.datetime :completed_at, null: false
      t.boolean  :saved
      t.string   :submission_type
      t.string   :court
    end
  end
end
