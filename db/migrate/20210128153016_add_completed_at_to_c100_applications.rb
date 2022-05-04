class AddCompletedAtToC100Applications < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :completed_at, :datetime
  end
end
