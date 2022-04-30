class AddSubstanceAbuseFields < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :substance_abuse, :string
    add_column :c100_applications, :substance_abuse_details, :text
  end
end
