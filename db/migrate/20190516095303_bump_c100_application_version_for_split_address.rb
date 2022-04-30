class BumpC100ApplicationVersionForSplitAddress < ActiveRecord::Migration[5.1]
  def change
    # Version 3 introduces split address fields form
    # New records will be created with version=3
    change_column_default :c100_applications, :version, from: 2, to: 3
  end
end
