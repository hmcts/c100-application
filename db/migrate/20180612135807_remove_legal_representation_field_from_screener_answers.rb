class RemoveLegalRepresentationFieldFromScreenerAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_column :screener_answers, :legal_representation, :string
  end
end
