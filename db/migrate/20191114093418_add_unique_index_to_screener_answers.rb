class AddUniqueIndexToScreenerAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_index :screener_answers, :c100_application_id
    add_index    :screener_answers, :c100_application_id, unique: true
  end
end
