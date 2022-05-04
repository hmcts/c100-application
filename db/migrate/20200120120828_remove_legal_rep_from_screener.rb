class RemoveLegalRepFromScreener < ActiveRecord::Migration[5.2]
  def change
    remove_column :screener_answers, :legal_representation, :string
  end
end
