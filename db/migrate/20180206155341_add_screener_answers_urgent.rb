class AddScreenerAnswersUrgent < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_answers, :urgent, :string, null: true
  end
end
