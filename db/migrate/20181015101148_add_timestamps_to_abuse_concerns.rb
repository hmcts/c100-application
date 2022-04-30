class AddTimestampsToAbuseConcerns < ActiveRecord::Migration[5.1]
  def change
    add_column :abuse_concerns, :created_at, :datetime
    add_column :abuse_concerns, :updated_at, :datetime
  end
end
