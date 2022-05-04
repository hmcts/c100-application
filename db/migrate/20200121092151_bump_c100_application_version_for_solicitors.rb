class BumpC100ApplicationVersionForSolicitors < ActiveRecord::Migration[5.2]
  def change
    # Version 4 introduces the ability to have a solicitor
    # New records will be created with version=4
    change_column_default :c100_applications, :version, from: 3, to: 4
  end
end
