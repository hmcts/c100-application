class AddScreenerAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :screener_answers, id: :uuid do |t|
      t.string :children_postcodes, null: true
      t.timestamps null: false
    end

    add_reference :screener_answers, :c100_application, type: :uuid, foreign_key: true
  end
end
