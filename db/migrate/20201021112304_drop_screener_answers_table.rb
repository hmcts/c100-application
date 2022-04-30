class DropScreenerAnswersTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :screener_answers
  end
end
