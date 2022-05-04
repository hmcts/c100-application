class AddInternationalFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :international_resident, :string
    add_column :c100_applications, :international_resident_details, :text

    add_column :c100_applications, :international_jurisdiction, :string
    add_column :c100_applications, :international_jurisdiction_details, :text

    add_column :c100_applications, :international_request, :string
    add_column :c100_applications, :international_request_details, :text
  end
end
