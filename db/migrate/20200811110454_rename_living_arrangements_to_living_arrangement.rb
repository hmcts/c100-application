class RenameLivingArrangementsToLivingArrangement < ActiveRecord::Migration[5.2]
  def change
    rename_column  :relationships, :living_arrangements, :living_arrangement
  end
end
