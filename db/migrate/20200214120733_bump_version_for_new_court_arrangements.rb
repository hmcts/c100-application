class BumpVersionForNewCourtArrangements < ActiveRecord::Migration[5.2]
  def change
    # Version 5 introduces the new redesigned attending court journey.
    # New records will be created with version=5
    change_column_default :c100_applications, :version, from: 4, to: 5
  end
end
