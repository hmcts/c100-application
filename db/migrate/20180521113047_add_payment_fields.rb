class AddPaymentFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :payment_type, :string
    add_column :c100_applications, :solicitor_account_number, :string
    # we already have from a previous migration the `hwf_reference_number` column
  end
end
