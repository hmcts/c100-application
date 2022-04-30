class RefactorApplicationsAudit < ActiveRecord::Migration[5.1]
  #
  # Current stored data is preserved and nothing is lost.
  # We just move around some fields to the new `metadata` column.
  # Rollback will not restore to the previous state but this is on purpose.
  #
  def up
    add_column :completed_applications_audit, :metadata, :json, default: {}

    migrate_current_data!

    remove_column :completed_applications_audit, :saved
    remove_column :completed_applications_audit, :urgent_hearing
  end

  def down
    remove_column :completed_applications_audit, :metadata
    add_column :completed_applications_audit, :saved, :boolean
    add_column :completed_applications_audit, :urgent_hearing, :string
  end

  private

  def migrate_current_data!
    CompletedApplicationsAudit.all.each do |record|
      record.update_column(:metadata, {
        saved_for_later: record.saved,
        urgent_hearing: record.urgent_hearing,
      })
    end
  end
end
