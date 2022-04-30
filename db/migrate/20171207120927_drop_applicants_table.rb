class DropApplicantsTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :applicants
  end
end
