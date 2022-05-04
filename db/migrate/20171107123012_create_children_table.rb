class CreateChildrenTable < ActiveRecord::Migration[5.0]
  def change
    create_table :children, id: :uuid do |t|
      t.timestamps null: false

      t.string  :full_name
      t.date    :dob
      t.boolean :dob_unknown
      t.string  :gender
      t.text    :orders_applied_for
      t.text    :applicants_relationship
      t.text    :respondents_relationship
    end

    add_reference :children, :c100_application, type: :uuid, foreign_key: true
  end
end
