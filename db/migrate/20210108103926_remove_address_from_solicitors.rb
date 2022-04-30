class RemoveAddressFromSolicitors < ActiveRecord::Migration[5.2]
  def change
    remove_column :solicitors, :address, :string
  end
end
