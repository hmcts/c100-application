class AddScreenerAnswersParent < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_answers, :parent, :string, null: true
  end
end
