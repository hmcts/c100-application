class AddUniqueIndexToEmailSubmissions < ActiveRecord::Migration[5.2]
  def change
    remove_index :email_submissions, :c100_application_id
    add_index    :email_submissions, :c100_application_id, unique: true
  end
end
