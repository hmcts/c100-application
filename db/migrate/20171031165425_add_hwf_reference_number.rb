class AddHwfReferenceNumber < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :hwf_reference_number, :string
  end
end
