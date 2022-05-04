class RemoveConsentOrderField < ActiveRecord::Migration[5.0]
  def change
    remove_column :asking_orders, :consent_order
  end
end
