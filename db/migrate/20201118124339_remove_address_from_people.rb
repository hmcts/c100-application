class RemoveAddressFromPeople < ActiveRecord::Migration[5.2]
  def change
    remove_column :people, :address, :string
  end
end
