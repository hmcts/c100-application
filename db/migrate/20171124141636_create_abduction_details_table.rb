class CreateAbductionDetailsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :abduction_details, id: :uuid do |t|
      t.string  :children_have_passport

      t.string  :international_risk
      t.string  :passport_office_notified
      t.string  :children_multiple_passports
      t.boolean :passport_possession_mother
      t.boolean :passport_possession_father
      t.boolean :passport_possession_other
      t.text    :passport_possession_other_details

      t.string  :previous_attempt
      t.text    :previous_attempt_details
      t.string  :previous_attempt_agency_involved
      t.text    :previous_attempt_agency_details

      t.text    :risk_details
    end

    add_reference :abduction_details, :c100_application, type: :uuid, foreign_key: true
  end
end
