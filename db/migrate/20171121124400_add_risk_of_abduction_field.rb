class AddRiskOfAbductionField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :risk_of_abduction, :string
  end
end
