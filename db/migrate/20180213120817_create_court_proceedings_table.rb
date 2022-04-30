class CreateCourtProceedingsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :court_proceedings, id: :uuid do |t|
      t.text :children_names
      t.string :court_name
      t.string :case_number
      t.string :proceedings_date
      t.text :cafcass_details
      t.text :order_types
      t.text :previous_details
    end

    add_reference :court_proceedings, :c100_application, type: :uuid, foreign_key: true
  end
end
