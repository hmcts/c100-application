class AddScreenerAnswersWrittenAgreement < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_answers, :written_agreement, :string, null: true
  end
end
