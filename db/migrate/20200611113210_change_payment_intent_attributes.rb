class ChangePaymentIntentAttributes < ActiveRecord::Migration[5.2]
  def change
    remove_column :payment_intents, :finished_at, :datetime
    remove_column :payment_intents, :status, :string

    add_column :payment_intents, :state, :jsonb, default: {}, null: false
  end
end
