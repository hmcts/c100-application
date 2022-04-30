class CreateAbuseConcernsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :abuse_concerns, id: :uuid do |t|
      t.string :subject
      t.string :kind
      t.string :answer
      t.text   :behaviour_description
      t.string :behaviour_start
      t.string :behaviour_ongoing
      t.string :behaviour_stop
      t.string :asked_for_help
      t.string :help_party
      t.string :help_provided
      t.text   :help_description
    end

    add_reference :abuse_concerns, :c100_application, type: :uuid, foreign_key: true
  end
end
