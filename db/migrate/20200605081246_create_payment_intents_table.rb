class CreatePaymentIntentsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_intents, id: :uuid do |t|
      t.timestamps

      t.string :nonce
      t.string :payment_id
      t.string :status, null: false, default: 'ready'

      t.datetime :finished_at
    end

    add_reference :payment_intents, :c100_application, type: :uuid, foreign_key: true, index: { unique: true }
  end
end
