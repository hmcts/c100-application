class RemoveInternationalResidentDetailsFromC100Applications < ActiveRecord::Migration[5.1]
  def change
    remove_column :c100_applications, :international_resident_details, :string
  end
end
