class EmailSubmissionsAudit < ActiveRecord::Migration[5.1]
  def change
    create_table :email_submissions_audit, id: false do |t|
      t.uuid :id, primary_key: true

      t.string :to, null: false
      t.string :reference, null: false
      t.string :status, null: false

      t.datetime :created_at, null: false
      t.datetime :completed_at, null: false
      t.datetime :sent_at
    end

    add_index :email_submissions_audit, :reference, unique: false
  end
end
