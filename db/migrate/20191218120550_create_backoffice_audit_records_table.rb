class CreateBackofficeAuditRecordsTable < ActiveRecord::Migration[5.2]
  def change
    # we do not need this field in the backoffice_users table
    remove_column :backoffice_users, :user_id, :string

    create_table :backoffice_audit_records, id: :uuid do |t|
      t.datetime :created_at, null: false
      t.string :author, null: false, index: true
      t.string :action, null: false
      t.json :details, default: {}
    end
  end
end
