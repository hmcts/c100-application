class AddOtherAbuseField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :other_abuse, :string
  end
end
