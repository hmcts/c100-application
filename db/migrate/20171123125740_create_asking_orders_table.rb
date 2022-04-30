class CreateAskingOrdersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :asking_orders, id: :uuid do |t|
      t.boolean :child_home
      t.boolean :child_times
      t.boolean :child_contact

      t.boolean :child_specific_issue
      t.boolean :child_specific_issue_school
      t.boolean :child_specific_issue_religion
      t.boolean :child_specific_issue_name
      t.boolean :child_specific_issue_medical
      t.boolean :child_specific_issue_abroad

      t.boolean :consent_order
      t.boolean :child_return
      t.boolean :child_abduction
      t.boolean :child_flight

      t.boolean :other
      t.text    :other_details
      t.boolean :child_arrangements_order
      t.boolean :prohibited_steps_order
      t.boolean :specific_issue_order
    end

    add_reference :asking_orders, :c100_application, type: :uuid, foreign_key: true
  end
end
