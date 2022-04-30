class AddWelshFieldsToCourtArrangements < ActiveRecord::Migration[5.2]
  def change
    add_column :court_arrangements, :welsh_language, :boolean
    add_column :court_arrangements, :welsh_language_details, :text
  end
end
