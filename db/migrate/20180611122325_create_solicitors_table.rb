class CreateSolicitorsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :solicitors, id: :uuid do |t|
      t.timestamps null: false

      t.string  :full_name
      t.string  :firm_name
      t.string  :reference
      t.text    :address
      t.string  :dx_number
      t.string  :phone_number
      t.string  :fax_number
      t.string  :email
    end

    add_reference :solicitors, :c100_application, type: :uuid, foreign_key: true
  end
end
