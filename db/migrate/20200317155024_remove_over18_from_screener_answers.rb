class RemoveOver18FromScreenerAnswers < ActiveRecord::Migration[5.2]
  def change
    remove_column :screener_answers, :over18, :string
  end
end
