class RemoveWrittenAgreementFromScreener < ActiveRecord::Migration[5.2]
  def change
    remove_column :screener_answers, :written_agreement, :string
  end
end
