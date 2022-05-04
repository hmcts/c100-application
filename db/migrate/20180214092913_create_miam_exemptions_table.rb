class CreateMiamExemptionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :miam_exemptions, id: :uuid do |t|
      t.string :domestic,   array: true, default: []
      t.string :protection, array: true, default: []
      t.string :urgency,    array: true, default: []
      t.string :adr,        array: true, default: []
      t.string :misc,       array: true, default: []
    end

    add_reference :miam_exemptions, :c100_application, type: :uuid, foreign_key: true
  end
end
