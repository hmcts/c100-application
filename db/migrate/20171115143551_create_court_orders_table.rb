class CreateCourtOrdersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :court_orders, id: :uuid do |t|
      t.string :non_molestation
      t.date   :non_molestation_issue_date
      t.string :non_molestation_length
      t.string :non_molestation_is_current
      t.string :non_molestation_court_name

      t.string :occupation
      t.date   :occupation_issue_date
      t.string :occupation_length
      t.string :occupation_is_current
      t.string :occupation_court_name

      t.string :forced_marriage_protection
      t.date   :forced_marriage_protection_issue_date
      t.string :forced_marriage_protection_length
      t.string :forced_marriage_protection_is_current
      t.string :forced_marriage_protection_court_name

      t.string :restraining
      t.date   :restraining_issue_date
      t.string :restraining_length
      t.string :restraining_is_current
      t.string :restraining_court_name

      t.string :injunctive
      t.date   :injunctive_issue_date
      t.string :injunctive_length
      t.string :injunctive_is_current
      t.string :injunctive_court_name

      t.string :undertaking
      t.date   :undertaking_issue_date
      t.string :undertaking_length
      t.string :undertaking_is_current
      t.string :undertaking_court_name
    end

    add_reference :court_orders, :c100_application, type: :uuid, foreign_key: true
  end
end
