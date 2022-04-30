class AddSpecialAssistanceFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :special_assistance, :string
    add_column :c100_applications, :special_assistance_details, :text

    add_column :c100_applications, :special_arrangements, :string
    add_column :c100_applications, :special_arrangements_details, :text
  end
end
