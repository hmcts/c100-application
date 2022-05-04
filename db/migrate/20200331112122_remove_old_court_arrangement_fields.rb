class RemoveOldCourtArrangementFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :c100_applications, :language_help, :string
    remove_column :c100_applications, :language_help_details, :text

    remove_column :c100_applications, :intermediary_help, :string
    remove_column :c100_applications, :intermediary_help_details, :text

    remove_column :c100_applications, :special_assistance, :string
    remove_column :c100_applications, :special_assistance_details, :text

    remove_column :c100_applications, :special_arrangements, :string
    remove_column :c100_applications, :special_arrangements_details, :text
  end
end
