class RemoveParentFromScreener < ActiveRecord::Migration[5.2]
  def change
    remove_column :screener_answers, :parent, :string
  end
end
