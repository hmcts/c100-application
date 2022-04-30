class CumulativeDataTable < ActiveRecord::Migration[5.1]
  def change
    create_table :cumulative_data, id: false do |t|
      t.datetime :created_at, null: false
      t.date :reading_date, primary_key: true

      t.integer :applications_created
      t.integer :applications_eligible
      t.integer :applications_completed
      t.integer :applications_saved
      t.integer :applications_online_submission
      t.integer :applications_postal_submission

      t.integer :miam_kickouts
      t.integer :miam_expired
    end
  end
end
