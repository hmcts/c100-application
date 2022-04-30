class AddEmailSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :email_submissions, id: :uuid do |t|
      t.string    :to_address
      t.string    :email_copy_to
      t.datetime  :sent_at
      t.string    :message_id
      t.datetime  :user_copy_sent_at
      t.string    :user_copy_message_id
    end

    add_reference :email_submissions, :c100_application, type: :uuid, foreign_key: true
  end
end
