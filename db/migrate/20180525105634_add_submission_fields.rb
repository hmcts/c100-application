class AddSubmissionFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :submission_type, :string
    add_column :c100_applications, :receipt_email, :string
  end
end
