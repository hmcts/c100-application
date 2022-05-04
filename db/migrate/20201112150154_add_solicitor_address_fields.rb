class AddSolicitorAddressFields < ActiveRecord::Migration[5.2]
  def change
    add_column :solicitors, :address_data, :json, default: {}
  end
end
