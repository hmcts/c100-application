class AddScreenerAnswersLocalCourt < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_answers, :local_court, :json, null: true
  end
end
