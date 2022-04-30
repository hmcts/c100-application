class AddResidenceKeepPrivateToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :residence_keep_private, :string
  end
end
