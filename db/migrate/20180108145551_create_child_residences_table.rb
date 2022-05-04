class CreateChildResidencesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :child_residences, id: :uuid do |t|
      t.uuid    :child_id, index: true
      t.string  :person_ids, array: true, default: []
      t.boolean :other
      t.string  :other_full_name
    end

    add_foreign_key :child_residences, :people, column: :child_id
  end
end
