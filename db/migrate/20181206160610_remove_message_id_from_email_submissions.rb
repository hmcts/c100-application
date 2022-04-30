class RemoveMessageIdFromEmailSubmissions < ActiveRecord::Migration[5.1]
  def change
    remove_column :email_submissions, :message_id, :string
    remove_column :email_submissions, :user_copy_message_id, :string
  end
end
