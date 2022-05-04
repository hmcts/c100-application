class AddLanguageHelpFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :language_help, :string
    add_column :c100_applications, :language_help_details, :text
  end
end
