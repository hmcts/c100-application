class RemoveInternationalRiskField < ActiveRecord::Migration[5.1]
  def change
    remove_column :abduction_details, :international_risk, :string
  end
end
