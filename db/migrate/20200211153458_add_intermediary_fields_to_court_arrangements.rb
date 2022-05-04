class AddIntermediaryFieldsToCourtArrangements < ActiveRecord::Migration[5.2]
  def change
    add_column :court_arrangements, :intermediary_help, :string
    add_column :court_arrangements, :intermediary_help_details, :text
  end
end
