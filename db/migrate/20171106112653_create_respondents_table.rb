class CreateRespondentsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :respondents, id: :uuid do |t|
      t.timestamps null: false

      t.string  :full_name
      t.string  :has_previous_name
      t.string  :previous_full_name
      t.string  :gender
      t.date    :dob
      t.boolean :dob_unknown
      t.string  :birthplace
      t.string  :address
      t.string  :postcode
      t.boolean :postcode_unknown
      t.string  :home_phone
      t.string  :mobile_phone
      t.boolean :mobile_phone_unknown
      t.string  :email
      t.boolean :email_unknown
    end

    add_reference :respondents, :c100_application, type: :uuid, foreign_key: true
  end
end
