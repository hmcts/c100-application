class AddMiamVoucherToC100Applications < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :mediation_voucher_scheme, :string
  end
end
