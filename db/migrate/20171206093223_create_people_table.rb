class CreatePeopleTable < ActiveRecord::Migration[5.0]
  def change
    create_table :people, id: :uuid do |t|
      t.timestamps null: false

      t.string  :type, null: false
      t.string  :name
      t.string  :full_name
      t.string  :has_previous_name
      t.string  :previous_name
      t.string  :gender
      t.date    :dob
      t.boolean :dob_unknown, default: false
      t.string  :age_estimate
      t.string  :birthplace
      t.text    :address
      t.string  :postcode
      t.boolean :postcode_unknown, default: false
      t.string  :home_phone
      t.boolean :home_phone_unknown, default: false
      t.string  :mobile_phone
      t.boolean :mobile_phone_unknown, default: false
      t.string  :email
      t.boolean :email_unknown, default: false
      t.string  :residence_requirement_met
      t.text    :residence_history
    end

    add_reference :people, :c100_application, type: :uuid, foreign_key: true
  end
end
