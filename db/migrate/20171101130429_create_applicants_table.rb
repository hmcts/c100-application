class CreateApplicantsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :applicants, id: :uuid do |t|
      t.timestamps null: false

      t.string :full_name
      t.string :has_previous_name
      t.string :previous_full_name
      t.string :gender
      t.string :birthplace
      t.string :address
      t.string :postcode
      t.string :home_phone
      t.string :mobile_phone
      t.string :email
    end

    add_reference :applicants, :c100_application, type: :uuid, foreign_key: true
  end
end
