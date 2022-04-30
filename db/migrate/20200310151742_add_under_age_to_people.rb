class AddUnderAgeToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :under_age, :boolean
  end
end
