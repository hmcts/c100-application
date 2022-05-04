class DropRespondentsTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :respondents
  end
end
