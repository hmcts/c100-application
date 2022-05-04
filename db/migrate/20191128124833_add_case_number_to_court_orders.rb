class AddCaseNumberToCourtOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :court_orders, :non_molestation_case_number, :string
    add_column :court_orders, :occupation_case_number, :string
    add_column :court_orders, :forced_marriage_protection_case_number, :string
    add_column :court_orders, :restraining_case_number, :string
    add_column :court_orders, :injunctive_case_number, :string
    add_column :court_orders, :undertaking_case_number, :string
  end
end
