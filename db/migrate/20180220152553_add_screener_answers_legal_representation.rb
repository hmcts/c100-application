class AddScreenerAnswersLegalRepresentation < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_answers, :legal_representation, :string, null: true
  end
end
