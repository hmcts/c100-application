class DecoupleLocalCourtDataFields < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :children_postcode, :string

    create_table :courts, id: false do |t|
      t.string :id, primary_key: true
      t.timestamps

      t.string :name,    null: false
      t.string :email,   null: false
      t.string :gbs,     null: false
      t.jsonb  :address, null: false, default: {}
    end

    add_reference :c100_applications, :court, type: :string, foreign_key: true
  end
end
