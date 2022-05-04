class AddTimestampsToEmailSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :email_submissions, :created_at, :datetime
    add_column :email_submissions, :updated_at, :datetime
  end
end
