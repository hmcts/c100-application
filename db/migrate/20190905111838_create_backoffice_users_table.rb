class CreateBackofficeUsersTable < ActiveRecord::Migration[5.1]
  def change
    create_table :backoffice_users, id: :uuid do |t|
      t.string :email, null: false
      t.string :user_id

      t.boolean :active, default: true

      t.integer :logins_count, default: 0

      t.datetime :current_login_at
      t.datetime :last_login_at
    end

    add_index :backoffice_users, :email, unique: true
  end
end
