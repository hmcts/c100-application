class ChangeAlternativeCourtField < ActiveRecord::Migration[5.0]
  def up
    remove_column :c100_applications, :alternative_court
    add_column :c100_applications, :court_acknowledgement, :boolean
  end

  def down
    remove_column :c100_applications, :court_acknowledgement
    add_column :c100_applications, :alternative_court, :string
  end
end
