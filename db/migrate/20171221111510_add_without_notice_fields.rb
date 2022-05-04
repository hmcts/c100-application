class AddWithoutNoticeFields < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :without_notice, :string
    add_column :c100_applications, :without_notice_details, :text

    add_column :c100_applications, :without_notice_frustrate, :string
    add_column :c100_applications, :without_notice_frustrate_details, :text

    add_column :c100_applications, :without_notice_impossible, :string
    add_column :c100_applications, :without_notice_impossible_details, :text
  end
end
