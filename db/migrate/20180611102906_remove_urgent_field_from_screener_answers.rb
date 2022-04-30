class RemoveUrgentFieldFromScreenerAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_column :screener_answers, :urgent, :string
  end
end
