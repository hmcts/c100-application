class RestoreInternationalResidentDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :international_resident_details, :text
  end
end
