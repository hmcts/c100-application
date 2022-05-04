class AddScreenerAnswersOver18 < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_answers, :over18, :string, null: true
  end
end
