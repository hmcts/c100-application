class AddContanctDetailsKeepPrivate < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :email_keep_private, :string
    add_column :people, :phone_keep_private, :string
    add_column :people, :mobile_keep_private, :string
  end
end
