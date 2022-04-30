class AddAddressConfidentialityField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :address_confidentiality, :string
  end
end
