class AddPermissionSoughtFields < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :permission_sought,  :string
    add_column :c100_applications, :permission_details, :text
  end
end
