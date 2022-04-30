class DropAskingOrdersTable < ActiveRecord::Migration[5.1]
  #
  # Note: this is a one-way migration, so no rollback is provided.
  # This is safe as we are in the development phase yet and the service is
  # yet to be deployed, so we don't have existing data to care about, etc.
  #
  def up
    drop_table :asking_orders
  end
end
