class AddSpecialArrangementsFields < ActiveRecord::Migration[5.2]
  def change
    add_column :court_arrangements, :special_arrangements, :string, array: true, default: []
    add_column :court_arrangements, :special_arrangements_details, :text
  end
end
