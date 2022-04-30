class CreateRelationshipsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships, id: :uuid do |t|
      t.string :relation
      t.string :relation_other_value
      t.uuid   :child_id,  null: false
      t.uuid   :person_id, null: false
    end

    add_index :relationships, [:child_id, :person_id], unique: true

    add_reference :relationships, :c100_application, type: :uuid, foreign_key: true

    add_foreign_key :relationships, :people, column: :child_id
    add_foreign_key :relationships, :people, column: :person_id
  end
end
