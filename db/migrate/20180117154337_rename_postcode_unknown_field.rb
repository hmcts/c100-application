class RenamePostcodeUnknownField < ActiveRecord::Migration[5.1]
  def change
    rename_column :people, :postcode_unknown, :address_unknown
  end
end
