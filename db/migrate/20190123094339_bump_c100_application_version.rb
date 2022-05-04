class BumpC100ApplicationVersion < ActiveRecord::Migration[5.1]
  def change
    # Version 2 introduces `full_name` split into `first_name` and `last_name`.
    # New records will be created with version=2
    change_column_default :c100_applications, :version, from: 1, to: 2
  end
end
