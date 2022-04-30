class CreateCourtArrangementsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :court_arrangements, id: :uuid do |t|
      t.timestamps null: false

      t.boolean :language_interpreter
      t.text :language_interpreter_details
      t.boolean :sign_language_interpreter
      t.text :sign_language_interpreter_details
    end

    add_reference :court_arrangements, :c100_application, type: :uuid, foreign_key: true, index: { unique: true }
  end
end
