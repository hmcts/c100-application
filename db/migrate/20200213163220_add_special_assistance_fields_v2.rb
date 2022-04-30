class AddSpecialAssistanceFieldsV2 < ActiveRecord::Migration[5.2]
  def change
    add_column :court_arrangements, :special_assistance, :string, array: true, default: []
    add_column :court_arrangements, :special_assistance_details, :text
  end
end
