class AddUrgentHearingFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :urgent_hearing, :string
    add_column :c100_applications, :urgent_hearing_details, :text
    add_column :c100_applications, :urgent_hearing_when, :string
    add_column :c100_applications, :urgent_hearing_short_notice, :string
    add_column :c100_applications, :urgent_hearing_short_notice_details, :text
  end
end
