class AddAddressDataToPeople < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :address_data, :json, default: {}
  end
end
